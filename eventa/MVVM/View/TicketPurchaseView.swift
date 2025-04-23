import SwiftUI

struct TicketPurchaseView: View {
    @StateObject private var viewModel: TicketPurchaseViewModel
    @Environment(\.presentationMode) var presentationMode
    var navigateToHome: (() -> Void)?
    
    init(event: EventItem, navigateToHome: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: TicketPurchaseViewModel(event: event))
        self.navigateToHome = navigateToHome
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                if viewModel.purchaseComplete {
                    purchaseSuccessView
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            eventInfoView
                            ticketSelectionView
                            quantitySelectionView
                            paymentMethodView
                            orderSummaryView
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                    
                    paymentButtonView
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.showingPaymentError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.purchaseError ?? "An error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var headerView: some View {
        ZStack {
            Color.blue
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Purchase Tickets")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.model.event.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(viewModel.model.event.month) \(viewModel.model.event.day) • \(viewModel.model.event.timeRange)")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .frame(height: 140)
    }
    
    private var eventInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Information")
                .font(.system(size: 18, weight: .bold))
            
            HStack(spacing: 16) {
                Image(viewModel.model.event.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.model.event.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("\(viewModel.model.event.location), \(viewModel.model.event.city)")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Text("\(viewModel.model.event.month) \(viewModel.model.event.day) • \(viewModel.model.event.timeRange)")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var ticketSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Ticket Type")
                .font(.system(size: 18, weight: .bold))
            
            ForEach(viewModel.model.availableTicketTypes) { ticketType in
                Button(action: {
                    viewModel.selectTicketType(ticketType)
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ticketType.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(ticketType.description)
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Text("LKR \(String(format: "%.2f", ticketType.price))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                        
                        if viewModel.selectedTicketType?.id == ticketType.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .padding(.leading, 8)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.selectedTicketType?.id == ticketType.id ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var quantitySelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quantity")
                .font(.system(size: 18, weight: .bold))
            
            HStack {
                Button(action: {
                    viewModel.decrementTicketQuantity()
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Text("\(viewModel.ticketQuantity)")
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 50)
                
                Button(action: {
                    viewModel.incrementTicketQuantity()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                if let selectedTicket = viewModel.selectedTicketType {
                    Text("Max: \(selectedTicket.maxQuantity)")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var paymentMethodView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Method")
                .font(.system(size: 18, weight: .bold))
            
            ForEach(viewModel.model.paymentMethods) { method in
                Button(action: {
                    viewModel.selectPaymentMethod(method)
                }) {
                    HStack {
                        Image(systemName: method.icon)
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                        
                        Text(method.name)
                            .font(.system(size: 16, weight: .medium))
                        
                        if let lastDigits = method.lastDigits {
                            Text("•••• \(lastDigits)")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        if viewModel.selectedPaymentMethod?.id == method.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.selectedPaymentMethod?.id == method.id ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var orderSummaryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Summary")
                .font(.system(size: 18, weight: .bold))
            
            VStack(spacing: 12) {
                HStack {
                    Text("Ticket Price")
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Spacer()
                    
                    if let selectedTicket = viewModel.selectedTicketType {
                        Text("LKR \(String(format: "%.2f", selectedTicket.price)) × \(viewModel.ticketQuantity)")
                            .font(.system(size: 16))
                    }
                }
                
                HStack {
                    Text("Subtotal")
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Spacer()
                    
                    Text("LKR \(String(format: "%.2f", viewModel.calculateTotalPrice()))")
                        .font(.system(size: 16))
                }
                
                HStack {
                    Text("Service Fee")
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.7))
                    
                    Spacer()
                    
                    Text("LKR \(String(format: "%.2f", viewModel.calculateServiceFee()))")
                        .font(.system(size: 16))
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    Text("LKR \(String(format: "%.2f", viewModel.calculateGrandTotal()))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var paymentButtonView: some View {
        VStack {
            Button(action: {
                viewModel.processPayment()
            }) {
                if viewModel.isProcessingPayment {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                } else {
                    Text("Complete Purchase")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            .disabled(viewModel.isProcessingPayment)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
    
    private var purchaseSuccessView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Purchase Successful!")
                .font(.system(size: 24, weight: .bold))
            
            VStack(spacing: 8) {
                Text("Thank you for your purchase")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.7))
                
                Text("Your tickets have been sent to your email")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {
                navigateToHome?()
            }) {
                Text("Return to Home")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
            }
        }
        .padding()
    }
}
