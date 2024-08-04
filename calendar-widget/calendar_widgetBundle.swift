//
//  calendar_widgetBundle.swift
//  calendar-widget
//
//  Created by caber on 04/08/24.
//

import WidgetKit
import SwiftUI

import WidgetKit
import SwiftUI

struct CalendarWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CalendarWidget()
    }
}
