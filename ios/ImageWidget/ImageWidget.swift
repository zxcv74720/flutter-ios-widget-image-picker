import WidgetKit
import SwiftUI
import Intents

struct WidgetData: Decodable, Hashable {
    let imagePath: String
    let timestamp: Int
}

struct FlutterEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FlutterEntry {
        FlutterEntry(date: Date(), widgetData: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FlutterEntry) -> ()) {
        let shareDefaults = UserDefaults.init(suiteName: "group.imagewidget")
        let flutterData = try? JSONDecoder().decode(WidgetData.self, from: (shareDefaults?.string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())
        let entry = FlutterEntry(date: Date(), widgetData: flutterData)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let shareDefaults = UserDefaults.init(suiteName: "group.imagewidget")
        let widgetDataString = shareDefaults?.string(forKey: "widgetData")
        
        let flutterData = try? JSONDecoder().decode(WidgetData.self, from: (widgetDataString?.data(using: .utf8)) ?? Data())
        
        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let entry = FlutterEntry(date: entryDate, widgetData: flutterData)
        
        let timeline = Timeline(entries: [entry], policy: .after(Date(timeIntervalSinceNow: 1)))
        completion(timeline)
    }
}

struct ImageWidget: Widget {
    let kind: String = "ios_widget_flutter"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            iosWidgetView(entry: entry)
        }
    }
}

struct iosWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader { geometry in
            if let widgetData = entry.widgetData,
               let image = UIImage(contentsOfFile: widgetData.imagePath) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                Text("이미지를 사용할 수 없습니다")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.gray)
            }
        }
    }
}
