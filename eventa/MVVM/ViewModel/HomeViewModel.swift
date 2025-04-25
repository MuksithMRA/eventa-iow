import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var model: HomeModel
    @Published var events: [EventItem] = []
    @Published var featuredEvents: [EventItem] = []
    @Published var upcomingEvents: [EventItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
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
        
        Task {
            await fetchEvents()
        }
    }
    
    func fetchEvents() async {
        await MainActor.run { isLoading = true }
        
        do {
            let featuredResponse = try await EventsAPI.shared.getFeaturedEvents()
            let allEventsResponse = try await EventsAPI.shared.getAllEvents()
            
            await MainActor.run {
                self.featuredEvents = convertToEventItems(events: featuredResponse.data.events)
                self.upcomingEvents = convertToEventItems(events: allEventsResponse.data.events)
                self.events = self.upcomingEvents
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load events: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    private func convertToEventItems(events: [Event]) -> [EventItem] {
        return events.map { event in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: event.date) ?? Date()
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"
            let month = monthFormatter.string(from: date)
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd"
            let day = dayFormatter.string(from: date)
            
            return EventItem(
                id: event.id,
                title: event.title,
                date: date,
                month: month,
                day: day,
                location: event.location.address,
                city: event.location.city,
                image: event.image.isEmpty ? "event1" : event.image,
                color: event.featured ? .blue : .gray,
                joinButtonText: "Join",
                timeRange: event.starttime + " - " + event.endtime,
                price: event.price.amount,
                isJoined: false
            )
        }
    }
    
    func joinEvent(event: EventItem) {
        guard let token = TokenManager.shared.getToken() else { return }
        
        Task {
            do {
                _ = try await EventsAPI.shared.joinEvent(token: token, id: event.id)
                await fetchEvents()
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to join event: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func postEvent() {
        navigateToNewEvent?()
    }
    
    func saveEvent(event: EventItem) {
        
    }
    
    func viewCategory() {
        
    }
    
    func viewNotifications() {
        
    }
}
