import Foundation
import SwiftUI

struct TicketType: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let maxQuantity: Int
}

struct PaymentMethod: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let lastDigits: String?
}

struct TicketPurchaseModel {
    let event: EventItem
    let availableTicketTypes: [TicketType]
    let paymentMethods: [PaymentMethod]
}
