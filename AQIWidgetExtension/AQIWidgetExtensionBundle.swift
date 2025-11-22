//
//  AQIWidgetExtensionBundle.swift
//  AQIWidgetExtension
//
//  Created by Suhas Gavas on 22/11/25.
//

import WidgetKit
import SwiftUI

@main
struct AQIWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        AQIWidgetExtension()
        AQIWidgetExtensionControl()
        AQIWidgetExtensionLiveActivity()
    }
}
