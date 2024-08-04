//
//  calendar_widget.swift
//  calendar-widget
//
//  Created by caber on 04/08/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        // Generate entries for the next 5 hours starting from the current date
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        // Create a timeline with the entries and specify the update policy
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CalendarWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dayOfWeek(date: entry.date).uppercased())
                    .foregroundColor(.red)
                Spacer()
                Text(entry.date, style: .date)
            }
            .padding([.top, .leading, .trailing])
            
            Divider()
            
            VStack(alignment: .leading) {
                ForEach(hoursForToday(date: entry.date), id: \.self) { hour in
                    Text(hour)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.leading)

            Divider()

            HStack {
                Text("TOMORROW")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding([.top, .leading, .trailing])

            VStack(alignment: .leading) {
                ForEach(hoursForTomorrow(date: entry.date), id: \.self) { hour in
                    Text(hour)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.leading)

            Spacer()
        }
        .background(Color.black)
        .foregroundColor(.white)
    }

    func dayOfWeek(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    func hoursForToday(date: Date) -> [String] {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        let hours = (currentHour..<24).map { String(format: "%02d:00", $0) }
        return hours
    }

    func hoursForTomorrow(date: Date) -> [String] {
        let hours = (0..<24).map { String(format: "%02d:00", $0) }
        return hours
    }
}

struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Calendar Widget")
        .description("This is an example widget.")
    }
}

struct CalendarWidget_Previews: PreviewProvider {
    static var previews: some View {
        CalendarWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

