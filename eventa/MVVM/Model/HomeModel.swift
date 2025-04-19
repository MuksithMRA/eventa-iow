import Foundation
import SwiftUI

struct HomeModel {
    let currentLocationTitle: String
    let searchPlaceholder: String
    let eventsForYouTitle: String
    let tabItems: [TabItem]
}

struct TabItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let selectedIcon: String
}

struct EventItem: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let month: String
    let day: String
    let location: String
    let city: String
    let image: String
    let color: Color
    let joinButtonText: String
    let timeRange: String
}
