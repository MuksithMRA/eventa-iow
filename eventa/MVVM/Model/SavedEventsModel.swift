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
            location: "Galle Road, Colombo 6",
            city: "Colombo",
            image: "profile",
            color: .blue,
            joinButtonText: "Join Now",
            timeRange: "10:00 AM - 2:00 PM",
            price: 1000.0,
            isJoined: false
        ),
        EventItem(
            title: "Cyber Security Workshop",
            date: Date(),
            month: "June",
            day: "08",
            location: "Galle Road, Colombo 6",
            city: "Colombo",
            image: "profile",
            color: .green,
            joinButtonText: "Join Now",
            timeRange: "1:00 PM - 5:00 PM",
            price: 1000.0,
            isJoined: false
        ),
        EventItem(
            title: "Cyber Security Workshop",
            date: Date(),
            month: "June",
            day: "08",
            location: "Galle Road, Colombo 6",
            city: "Colombo",
            image: "profile",
            color: .purple,
            joinButtonText: "Join Now",
            timeRange: "9:00 AM - 12:00 PM",
            price: 1000.0,
            isJoined: false
        )
    ]
    
    var publishedEvents: [EventItem] = [
    
        EventItem(
            title: "AI Development Workshop",
            date: Date().addingTimeInterval(86400 * 7), 
            month: "May",
            day: "15",
            location: "Tech Hub, Colombo 7",
            city: "Colombo",
            image: "profile",
            color: .orange,
            joinButtonText: "Join Now",
            timeRange: "9:00 AM - 4:00 PM",
            price: 1500.0,
            isJoined: false
        ),
        EventItem(
            title: "Mobile App Development Meetup",
            date: Date().addingTimeInterval(86400 * 14), 
            month: "May",
            day: "22",
            location: "Innovation Center, Colombo 3",
            city: "Colombo",
            image: "profile",
            color: .red,
            joinButtonText: "Join Now",
            timeRange: "2:00 PM - 6:00 PM",
            price: 800.0,
            isJoined: false
        ),
        EventItem(
            title: "Web Development Conference",
            date: Date().addingTimeInterval(86400 * 21), 
            month: "May",
            day: "29",
            location: "Grand Hotel, Colombo 4",
            city: "Colombo",
            image: "profile",
            color: .teal,
            joinButtonText: "Join Now",
            timeRange: "10:00 AM - 5:00 PM",
            price: 2000.0,
            isJoined: false
        )
    ]
}

enum SavedEventsTab {
    case published
    case saved
}
