import SwiftUI
import MapKit

struct MapModel {
    let title: String = "CURRENT LOCATION"
    let searchPlaceholder: String = "Search for events"
    let nearbyEventsTitle: String = "Nearby Events"
    
    var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), // Colombo, Sri Lanka
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var eventLocations: [EventLocation] = [
        EventLocation(
            id: 1,
            name: "Tech Conference 2025",
            coordinate: CLLocationCoordinate2D(latitude: 6.9320, longitude: 79.8478),
            type: .technology,
            date: "May 15",
            time: "09:00 AM - 05:00 PM"
        ),
        EventLocation(
            id: 2,
            name: "Music Festival",
            coordinate: CLLocationCoordinate2D(latitude: 6.9150, longitude: 79.8700),
            type: .music,
            date: "May 20",
            time: "06:00 PM - 11:00 PM"
        ),
        EventLocation(
            id: 3,
            name: "Food & Drink Expo",
            coordinate: CLLocationCoordinate2D(latitude: 6.9400, longitude: 79.8550),
            type: .food,
            date: "May 22",
            time: "10:00 AM - 08:00 PM"
        ),
        EventLocation(
            id: 4,
            name: "Art Exhibition",
            coordinate: CLLocationCoordinate2D(latitude: 6.9180, longitude: 79.8620),
            type: .art,
            date: "May 25",
            time: "11:00 AM - 07:00 PM"
        ),
        EventLocation(
            id: 5,
            name: "Startup Meetup",
            coordinate: CLLocationCoordinate2D(latitude: 6.9350, longitude: 79.8450),
            type: .business,
            date: "May 28",
            time: "02:00 PM - 06:00 PM"
        )
    ]
}

struct EventLocation: Identifiable {
    let id: Int
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: EventType
    let date: String
    let time: String
    
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
