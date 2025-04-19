import SwiftUI

struct ProfileModel {
    let userName: String = "John Doe"
    let userEmail: String = "john.doe@example.com"
    let userLocation: String = "Colombo, Sri Lanka"
    let userBio: String = "Event enthusiast and digital nomad. Love to explore new places and meet new people."
    let profileImage: String = "profile"
    
    let statsItems: [StatItem] = [
        StatItem(title: "Events", value: "24"),
        StatItem(title: "Following", value: "156"),
        StatItem(title: "Followers", value: "1.2K")
    ]
    
    let menuItems: [MenuItem] = [
        MenuItem(title: "Edit Profile", icon: "person.crop.circle"),
        MenuItem(title: "My Events", icon: "calendar"),
        MenuItem(title: "Saved Events", icon: "bookmark"),
        MenuItem(title: "Notifications", icon: "bell"),
        MenuItem(title: "Payment Methods", icon: "creditcard"),
        MenuItem(title: "Settings", icon: "gear"),
        MenuItem(title: "Help Center", icon: "questionmark.circle"),
        MenuItem(title: "Logout", icon: "arrow.right.square")
    ]
    
    let upcomingEvents: [ProfileEvent] = [
        ProfileEvent(
            id: 1,
            title: "Tech Conference 2025",
            date: "May 15",
            time: "09:00 AM - 05:00 PM",
            location: "Colombo Convention Center",
            image: "event1",
            color: .blue
        ),
        ProfileEvent(
            id: 2,
            title: "Music Festival",
            date: "May 20",
            time: "06:00 PM - 11:00 PM",
            location: "Viharamahadevi Park",
            image: "event2",
            color: .purple
        )
    ]
}

struct StatItem: Identifiable {
    var id = UUID()
    let title: String
    let value: String
}

struct MenuItem: Identifiable {
    var id = UUID()
    let title: String
    let icon: String
}

struct ProfileEvent: Identifiable {
    let id: Int
    let title: String
    let date: String
    let time: String
    let location: String
    let image: String
    let color: Color
}
