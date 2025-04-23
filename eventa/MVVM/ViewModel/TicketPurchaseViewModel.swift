import Foundation
import SwiftUI

class TicketPurchaseViewModel: ObservableObject {
    @Published var model: TicketPurchaseModel
    @Published var selectedTicketType: TicketType?
    @Published var ticketQuantity: Int = 1
    @Published var selectedPaymentMethod: PaymentMethod?
    @Published var isProcessingPayment: Bool = false
    @Published var purchaseComplete: Bool = false
    @Published var purchaseError: String?
    @Published var showingPaymentError: Bool = false
    
    init(event: EventItem) {
        let ticketTypes = [
            TicketType(name: "Standard", price: event.price, description: "Regular entry ticket", maxQuantity: 10),
            TicketType(name: "VIP", price: event.price * 2, description: "Priority seating and complimentary refreshments", maxQuantity: 5),
            TicketType(name: "Group", price: event.price * 0.8, description: "Discounted rate for groups of 3 or more", maxQuantity: 20)
        ]
        
        let paymentMethods = [
            PaymentMethod(name: "Visa", icon: "creditcard.fill", lastDigits: "4242"),
            PaymentMethod(name: "Mastercard", icon: "creditcard.fill", lastDigits: "5555"),
            PaymentMethod(name: "Apple Pay", icon: "apple.logo", lastDigits: nil)
        ]
        
        self.model = TicketPurchaseModel(
            event: event,
            availableTicketTypes: ticketTypes,
            paymentMethods: paymentMethods
        )
        
        self.selectedTicketType = ticketTypes.first
    }
    
    func incrementTicketQuantity() {
        guard let maxQuantity = selectedTicketType?.maxQuantity else { return }
        if ticketQuantity < maxQuantity {
            ticketQuantity += 1
        }
    }
    
    func decrementTicketQuantity() {
        if ticketQuantity > 1 {
            ticketQuantity -= 1
        }
    }
    
    func selectTicketType(_ ticketType: TicketType) {
        selectedTicketType = ticketType
        ticketQuantity = 1
    }
    
    func selectPaymentMethod(_ paymentMethod: PaymentMethod) {
        selectedPaymentMethod = paymentMethod
    }
    
    func calculateTotalPrice() -> Double {
        guard let ticketType = selectedTicketType else { return 0 }
        return ticketType.price * Double(ticketQuantity)
    }
    
    func calculateServiceFee() -> Double {
        return calculateTotalPrice() * 0.05
    }
    
    func calculateGrandTotal() -> Double {
        return calculateTotalPrice() + calculateServiceFee()
    }
    
    func processPayment() {
        guard selectedPaymentMethod != nil, selectedTicketType != nil else {
            purchaseError = "Please select a ticket type and payment method"
            showingPaymentError = true
            return
        }
        
        isProcessingPayment = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.isProcessingPayment = false
            self.purchaseComplete = true
        }
    }
}
