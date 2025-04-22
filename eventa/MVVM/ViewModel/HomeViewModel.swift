import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var model: HomeModel
    @Published var events: [EventItem]
    @Published var selectedTab: Int = 0
    @Published var userLocation: String = "Colombo, Sri Lanka"
    var navigateToNewEvent: (() -> Void)?
    
    init() {
        self.model = HomeModel(
            currentLocationTitle: "Current Location",
            searchPlaceholder: "Search for event",
            eventsForYouTitle: "Events for you",
            tabItems: [
                TabItem(title: "Home", icon: "house", selectedIcon: "house.fill"),
                TabItem(title: "Map", icon: "map", selectedIcon: "map.fill"),
                TabItem(title: "News Feed", icon: "newspaper", selectedIcon: "newspaper.fill"),
                TabItem(title: "Profile", icon: "person", selectedIcon: "person.fill")
            ]
        )
        
        self.events = [
            EventItem(
                title: "Cyber Security Workshop",
                date: Date(),
                month: "June",
                day: "08",
                location: "Galle Road, Colombo 6",
                city: "Colombo",
                image: "event1",
                color: .blue,
                joinButtonText: "Join",
                timeRange: "9:00 AM to 3:00 PM"
            ),
            EventItem(
                title: "Volunteer Beach Cleaning",
                date: Date(),
                month: "April",
                day: "12",
                location: "Mount Lavinia, Sri Lanka",
                city: "Colombo",
                image: "event2",
                color: .gray,
                joinButtonText: "Join",
                timeRange: "9:00 AM to 3:00 PM"
            )
        ]
    }
    
    func joinEvent(event: EventItem) {
        // Handle joining event
    }
    
    func postEvent() {
        navigateToNewEvent?()
    }
    
    func saveEvent(event: EventItem) {
        // Handle saving event
    }
    
    func viewCategory() {
        // Handle viewing category
    }
    
    func viewNotifications() {
        // Handle viewing notifications
    }
}
