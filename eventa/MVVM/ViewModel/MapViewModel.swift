import SwiftUI
import MapKit
import Combine

class MapViewModel: ObservableObject {
    @Published var model = MapModel()
    @Published var selectedTab: Int = 1
    @Published var selectedEvent: EventLocation?
    @Published var showEventDetails: Bool = false
    @Published var userLocation: String = "Colombo, Sri Lanka"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var searchQuery: String = ""
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        isLoading = true
        model.eventLocations = []
        
        Task {
            do {
                let response = try await EventsAPI.shared.getAllEvents()
                await MainActor.run {
                    self.model.eventLocations = convertToEventLocations(events: response.data.events)
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load events: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func convertToEventLocations(events: [Event]) -> [EventLocation] {
        return events.map { event in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: event.date) ?? Date()
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM d"
            let formattedDate = monthFormatter.string(from: date)
            
            let eventType = determineEventType(from: event.category)
            
            return EventLocation(
                id: Int(event.id.suffix(4), radix: 16) ?? 0,
                name: event.title,
                coordinate: CLLocationCoordinate2D(
                    latitude: event.location.coordinates.latitude,
                    longitude: event.location.coordinates.longitude
                ),
                type: eventType,
                date: formattedDate,
                time: "\(event.starttime) - \(event.endtime)",
                description: event.description,
                price: event.price.amount,
                eventId: event.id
            )
        }
    }
    
    private func determineEventType(from category: String) -> EventType {
        switch category.lowercased() {
        case "technology", "tech", "coding", "programming", "cybersecurity":
            return .technology
        case "music", "concert", "festival":
            return .music
        case "food", "culinary", "cooking", "dining":
            return .food
        case "art", "exhibition", "gallery", "creative":
            return .art
        default:
            return .business
        }
    }
    
    func viewEventDetails(_ event: EventLocation) {
        selectedEvent = event
        showEventDetails = true
    }
    
    func closeEventDetails() {
        showEventDetails = false
        selectedEvent = nil
    }
    
    func joinEvent() {
        if let event = selectedEvent, let eventId = event.eventId {
            guard let token = TokenManager.shared.getToken() else { return }
            
            Task {
                do {
                    _ = try await EventsAPI.shared.joinEvent(token: token, id: eventId)
                    await fetchEvents()
                    closeEventDetails()
                } catch {
                    await MainActor.run {
                        self.errorMessage = "Failed to join event: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func zoomToLocation(_ coordinate: CLLocationCoordinate2D) {
        model.mapRegion = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    func searchEventsOnMap(query: String) {
        guard !query.isEmpty else {
            fetchEvents()
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let response = try await EventsAPI.shared.searchEvents(query: query)
                await MainActor.run {
                    self.model.eventLocations = convertToEventLocations(events: response.data.events)
                    self.isLoading = false
                    
                    if !self.model.eventLocations.isEmpty {
                        let firstEvent = self.model.eventLocations[0]
                        self.model.mapRegion = MKCoordinateRegion(
                            center: firstEvent.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to search events: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func resetMapView() {
        model.mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    func getScreenPoint(for coordinate: CLLocationCoordinate2D) -> CGPoint? {

        return nil
    }
}
