import SwiftUI
import MapKit

struct MapModel {
    let title: String = "CURRENT LOCATION"
    let searchPlaceholder: String = "Search for events"
    let nearbyEventsTitle: String = "Nearby Events"
    
    var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var eventLocations: [EventLocation] = []
}

struct EventLocation: Identifiable {
    let id: Int
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: EventType
    let date: String
    let time: String
    let description: String
    let price: Double
    let eventId: String?
    
    var color: Color {
        switch type {
        case .technology:
            return .blue
        case .music:
            return .purple
        case .food:
            return .orange
        case .art:
            return .pink
        case .business:
            return .green
        }
    }
    
    var icon: String {
        switch type {
        case .technology:
            return "laptopcomputer"
        case .music:
            return "music.note"
        case .food:
            return "fork.knife"
        case .art:
            return "paintpalette"
        case .business:
            return "briefcase"
        }
    }
}

enum EventType {
    case technology
    case music
    case food
    case art
    case business
}
