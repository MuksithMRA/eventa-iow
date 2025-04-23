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
