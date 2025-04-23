import SwiftUI

class SavedEventsViewModel: ObservableObject {
    @Published var model = SavedEventsModel()
    @Published var selectedTab: SavedEventsTab = .saved

    var currentEvents: [EventItem] {
        switch selectedTab {
        case .published:
            return model.publishedEvents
        case .saved:
            return model.savedEvents
        }
    }
    
    func viewEventDetails(_ event: EventItem) {
        print("View event details: \(event.title)")
    }
    
    func goBack() {
        print("Go back")
    }
    
    func unsaveEvent(_ event: EventItem) {
        
        model.savedEvents.removeAll { $0.id == event.id }
    }
    
    func deletePublishedEvent(_ event: EventItem) {
        
        model.publishedEvents.removeAll { $0.id == event.id }
    }
    
    func editPublishedEvent(_ event: EventItem) {

        print("Editing event: \(event.title)")
    }
}
