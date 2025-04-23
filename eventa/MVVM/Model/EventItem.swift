import Foundation
import SwiftUI

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
    let price:Double
    let isJoined: Bool
}
