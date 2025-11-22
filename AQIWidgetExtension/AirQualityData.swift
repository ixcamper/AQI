//
//  AirQualityData.swift
//  AQI
//
//  Created by Suhas Gavas on 22/11/25.
//

import Foundation

// MARK: - Main Response Struct
struct AirQualityData: Codable {
    let status: String
    let data: AQIData
}

// MARK: - Main Data Container
struct AQIData: Codable {
    let city: String
    let state: String
    let country: String
    let location: Location
    let current: CurrentConditions
}

// MARK: - Location Details
struct Location: Codable {
    let type: String
    let coordinates: [Double] // Array for latitude and longitude
}

// MARK: - Current Conditions
struct CurrentConditions: Codable {
    let pollution: PollutionData
    let weather: WeatherData
}

// MARK: - Pollution Data
struct PollutionData: Codable {
    let ts: String // Timestamp as a string
    let aqius: Int // AQI value (US standard)
    let mainus: String // Main pollutant (US standard)
    let aqicn: Int // AQI value (CN standard)
    let maincn: String // Main pollutant (CN standard)
}

// MARK: - Weather Data
struct WeatherData: Codable {
    let ts: String // Timestamp as a string
    let ic: String // Weather icon code
    let hu: Int // Humidity (%)
    let pr: Int // Atmospheric pressure (hPa)
    let tp: Int // Temperature (°C)
    let wd: Int // Wind direction (degrees)
    let ws: Double // Wind speed (m/s)
    let heatIndex: Int? // Heat index, made optional as it might not always be present
}

