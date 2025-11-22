//
//  AQIWidgetExtensionLiveActivity.swift
//  AQIWidgetExtension
//
//  Created by Suhas Gavas on 22/11/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct AQIWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct AQIWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AQIWidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension AQIWidgetExtensionAttributes {
    fileprivate static var preview: AQIWidgetExtensionAttributes {
        AQIWidgetExtensionAttributes(name: "World")
    }
}

extension AQIWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: AQIWidgetExtensionAttributes.ContentState {
        AQIWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: AQIWidgetExtensionAttributes.ContentState {
         AQIWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: AQIWidgetExtensionAttributes.preview) {
   AQIWidgetExtensionLiveActivity()
} contentStates: {
    AQIWidgetExtensionAttributes.ContentState.smiley
    AQIWidgetExtensionAttributes.ContentState.starEyes
}
