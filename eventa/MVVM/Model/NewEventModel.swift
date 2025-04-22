import Foundation
import SwiftUI

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
    let priceText: String = "Price per person"
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
    var date: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date(timeIntervalSinceNow: 3600)
    var theme: Color = .blue
    var price: String = ""
    var isOffline: Bool = true
    var hostName: String = "John Doe"
    var hostImage: String = "profile"
}
