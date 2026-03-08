//
//  AQIWidgetExtension.swift
//  AQIWidgetExtension
//
//  Created by Suhas Gavas on 22/11/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), city: "", aqiValue: "--")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), city: "", aqiValue: "--")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        fetchAQI { result in
            var entries: [SimpleEntry] = []
            let currentDate = Date()

            switch result {
            case .success(let aqiData):
                let entry = SimpleEntry(date: currentDate, city: aqiData.data.city, aqiValue: String(aqiData.data.current.pollution.aqius))
                entries.append(entry)
            case .failure(_):
                let entry = SimpleEntry(date: Date(), city: "--", aqiValue: "--")
                entries.append(entry)
            }

            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let city: String
    let aqiValue: String
}

struct AQIWidgetExtensionEntryView : View {
    var entry: SimpleEntry

    init(entry: SimpleEntry) {
        self.entry = entry
    }

    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 4) {
                    Text("\(entry.city) AQI")
                        .font(.title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.yellow)
                    Spacer()
                }

                Text("\(String(describing: entry.aqiValue))")
                    .font(.system(size: 63, weight: .heavy))
                    .foregroundColor(.white)
            }
            .padding(2)
        }
        .containerBackground(getAQIColor(aqi: Int(entry.aqiValue)), for: .widget)
    }
}

struct AQIWidgetExtension: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AQIWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Suhas AQI Widget")
        .description("A simple widget to display AQI in Mumbai")
        .supportedFamilies([.systemSmall])
    }
}

func getAQIColor(aqi: Int?) -> Color {
    guard let aqi = aqi else {
        return Color.white
    }
    switch aqi {
        case 0...50:
            return Color.green
        case 51...100:
            return Color.yellow
        case 101...150:
            return Color.orange
        case 151...200:
            return Color.red
        case 201...300:
            return Color.purple
        case 301...:
            return Color(hex: "#800000")
        default:
            return Color.white
    }
}

func fetchAQI(completion: @escaping (Result<AirQualityData, Error>) -> Void) {
    guard let apiKey = apiKey(named: "AirVisualAPIKey") else {
        print("API Key missing")
        return
    }
    let endpoint = "https://api.airvisual.com/v2/nearest_city?key=\(apiKey)"

    print("endpoint \(endpoint)")
    guard let url = URL(string: endpoint) else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let jsonData = data else { return }

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Received JSON: \(jsonString)")
        }

        do {
            let decodedData = try JSONDecoder().decode(AirQualityData.self, from: jsonData)
            completion(.success(decodedData))
        } catch let decoderError {
            completion(.failure(decoderError))
        }
    }.resume()
}

// Utility function to fetch the API key from the plist
func apiKey(named key: String) -> String? {
    guard
        let url = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
        let data = try? Data(contentsOf: url),
        let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
    else {
        return nil
    }
    return plist[key] as? String
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview(as: .systemSmall) {
    AQIWidgetExtension()
} timeline: {
    SimpleEntry(date: Date(), city: "", aqiValue: "--")
}

