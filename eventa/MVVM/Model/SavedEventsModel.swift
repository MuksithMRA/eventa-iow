import SwiftUI

struct SavedEventsModel {
    let title: String = "Saved Events (3)"
    let publishedTabTitle: String = "Published"
    let savedTabTitle: String = "Saved"
    
    var savedEvents: [EventItem] = [
        EventItem(
            title: "Cyber Security Workshop",
            date: Date(),
            month: "June",
            day: "08",
            location: Location(address: "", city: "", coordinates: Coordinates(latitude: 0.0, longitude: 0.0)),
            image: "profile",
            color: .blue,
            joinButtonText: "Join Now",
            timeRange: "10:00 AM - 2:00 PM",
            price: 1000.0,
            isJoined: false,
            description: ""
        ),
        EventItem(
            title: "Cyber Security Workshop",
            date: Date(),
            month: "June",
            day: "08",
            location: Location(address: "", city: "", coordinates: Coordinates(latitude: 0.0, longitude: 0.0)),
            image: "profile",
            color: .green,
            joinButtonText: "Join Now",
            timeRange: "1:00 PM - 5:00 PM",
            price: 1000.0,
            isJoined: false,
            description: ""
        ),
        EventItem(
            title: "Cyber Security Workshop",
            date: Date(),
            month: "June",
            day: "08",
            location: Location(address: "", city: "", coordinates: Coordinates(latitude: 0.0, longitude: 0.0)),
            image: "profile",
            color: .purple,
            joinButtonText: "Join Now",
            timeRange: "9:00 AM - 12:00 PM",
            price: 1000.0,
            isJoined: false,
            description: ""
        )
    ]
    
    var publishedEvents: [EventItem] = [
    
        EventItem(
            title: "AI Development Workshop",
            date: Date().addingTimeInterval(86400 * 7), 
            month: "May",
            day: "15",
            location: Location(address: "", city: "", coordinates: Coordinates(latitude: 0.0, longitude: 0.0)),
            image: "profile",
            color: .orange,
            joinButtonText: "Join Now",
            timeRange: "9:00 AM - 4:00 PM",
            price: 1500.0,
            isJoined: false,
            description: ""
        ),
        EventItem(
            title: "Mobile App Development Meetup",
            date: Date().addingTimeInterval(86400 * 14), 
            month: "May",
            day: "22",
            location: Location(address: "", city: "", coordinates: Coordinates(latitude: 0.0, longitude: 0.0)),
            image: "profile",
            color: .red,
            joinButtonText: "Join Now",
            timeRange: "2:00 PM - 6:00 PM",
            price: 800.0,
            isJoined: false,
            description: ""
        ),
        EventItem(
            title: "Web Development Conference",
            date: Date().addingTimeInterval(86400 * 21), 
            month: "May",
            day: "29",
            location: Location(address: "", city: "", coordinates: Coordinates(latitude: 0.0, longitude: 0.0)),
            image: "profile",
            color: .teal,
            joinButtonText: "Join Now",
            timeRange: "10:00 AM - 5:00 PM",
            price: 2000.0,
            isJoined: false,
            description: ""
        )
    ]
}

enum SavedEventsTab {
    case published
    case saved
}
