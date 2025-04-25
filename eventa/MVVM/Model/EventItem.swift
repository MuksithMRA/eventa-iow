import Foundation
import SwiftUI

struct EventItem: Identifiable {
    let id: String
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
    let price: Double
    let isJoined: Bool
    
    init(id: String = UUID().uuidString, title: String, date: Date, month: String, day: String, location: String, city: String, image: String, color: Color, joinButtonText: String, timeRange: String, price: Double, isJoined: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.month = month
        self.day = day
        self.location = location
        self.city = city
        self.image = image
        self.color = color
        self.joinButtonText = joinButtonText
        self.timeRange = timeRange
        self.price = price
        self.isJoined = isJoined
    }
}
