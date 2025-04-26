import Foundation
import SwiftUI

struct EditableTicketType: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
    var description: String
    var maxQuantity: Int // -1 means unlimited
}


struct NewEventModel {
    let title: String = "New Event"
    let saveButtonText: String = "Save"
    let titlePlaceholder: String = "Title"
    let descriptionPlaceholder: String = "Description"
    let locationText: String = "Location"
    let dateText: String = "Date"
    let startTimeText: String = "Start time"
    let endTimeText: String = "End time"
    let themeText: String = "Theme"
    let priceText: String = "Tickets"
    let hostedByText: String = "Hosted By"
    let selectFromMapText: String = "Select from map"
    let selectFromCalendarText: String = "Select from Calendar"
    let selectFromPickerText: String = "Select from Picker"
    let themeSelectionText: String = "Please select a colour"
    let offlineText: String = "Offline"
    let onlineText: String = "Online"
}

struct EventFormData {
    var title: String = ""
    var description: String = ""
    var location: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var meetingLink: String = ""
    var date: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date(timeIntervalSinceNow: 3600)
    var theme: Color = .blue
    var price: String = "" // This will store the lowest ticket price
    var tickets: [EditableTicketType] = [
        EditableTicketType(name: "General Admission", price: 0, description: "Standard entry ticket", maxQuantity: -1)
    ]
    var isOffline: Bool = true
    var hostName: String = "John Doe"
    var hostImage: String = "profile"
    
    var lowestTicketPrice: String {
        let validPrices = tickets.map { $0.price }.filter { $0 > 0 }
        if let minPrice = validPrices.min() {
            return String(format: "%.2f", minPrice)
        }
        return ""
    }
}
