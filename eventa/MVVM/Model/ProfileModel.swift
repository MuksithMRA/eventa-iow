import SwiftUI

struct ProfileModel {
    var userName: String = "John Doe"
    var userEmail: String = "john.doe@example.com"
    var userLocation: String = "Colombo, Sri Lanka"
    var userBio: String = "Event enthusiast and digital nomad. Love to explore new places and meet new people."
    var profileImage: String = "profile"
    
    var statsItems: [StatItem] = [
        StatItem(title: "Events", value: "1"),
        StatItem(title: "Following", value: "0"),
        StatItem(title: "Followers", value: "0")
    ]
    
    var menuItems: [MenuItem] = [
        MenuItem(title: "Edit Profile", icon: "person.crop.circle"),
        MenuItem(title: "My Events", icon: "calendar"),
        MenuItem(title: "Saved Events", icon: "bookmark"),
        MenuItem(title: "Notifications", icon: "bell"),
        MenuItem(title: "Notification Settings", icon: "bell.badge"),
        MenuItem(title: "Payment Methods", icon: "creditcard"),
        MenuItem(title: "Settings", icon: "gear"),
        MenuItem(title: "Help Center", icon: "questionmark.circle"),
        MenuItem(title: "Logout", icon: "arrow.right.square")
    ]
    
    var upcomingEvents:[ProfileEvent] = []
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

