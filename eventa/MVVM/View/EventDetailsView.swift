import SwiftUI
import MapKit

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showReviews: Bool = false
    @State private var selectedReviewType: ReviewType = .positive
    var navigateToHome: (() -> Void)?
    var navigateToTicketPurchase: (() -> Void)?
    
    init(event: EventItem, navigateToHome: (() -> Void)? = nil, navigateToTicketPurchase: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(event: event))
        self.navigateToHome = navigateToHome
        self.navigateToTicketPurchase = navigateToTicketPurchase
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                headerView
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 30)
                        
                        participantsView
                        
                        eventDescriptionView
                        
                        mapView
                        
                        Spacer().frame(height: 100)
                    }
                    .padding(.top, 20)
                }
            }
            
            joinButtonView
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showReviews) {
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Reviews")
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                        showReviews = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                HStack(spacing: 16) {
                    Button(action: {
                        selectedReviewType = .positive
                    }) {
                        Text("Postive")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedReviewType == .positive ? .white : .blue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(selectedReviewType == .positive ? Color.blue : Color.blue.opacity(0.1))
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        selectedReviewType = .negative
                    }) {
                        Text("Negative")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedReviewType == .negative ? .white : .black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(selectedReviewType == .negative ? Color.black : Color.gray.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(0..<3) { _ in
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image("profile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Jake Willson")
                                            .font(.system(size: 16, weight: .medium))
                                        
                                        Text("Cyber Security enthusiast")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Text("A must-attend for cybersecurity pros!")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("This was an incredible experience! The live hacking demos were eye-opening, and the expert panels provided real-world insights. Can't wait for next year!")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black.opacity(0.7))
                                    .lineSpacing(4)
                            }
                            .padding(16)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.white)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private var headerView: some View {
        ZStack {
            Color.blue
            
            Image(viewModel.model.event.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 280)
                .opacity(0.2)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        if let navigateToHome = navigateToHome {
                            navigateToHome()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Button(action: {
                            showReviews = true
                        }) {
                            Text("Reviews")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    if !viewModel.isLoading {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.model.event.day)
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                            
                            Text(viewModel.model.event.month)
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 12)
                        
                        Text(viewModel.model.event.title)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding(.bottom, 12)
                        
                        Text("LKR \(String(format: "%.0f", viewModel.model.event.price))")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.bottom, 16)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            Text(viewModel.model.event.location.address)
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .frame(height: 280)
        .zIndex(1) 
    }

    private var eventDescriptionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Description")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 16)
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 20)
            } else if !viewModel.model.event.description.isEmpty {
                Text(viewModel.model.event.description)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.7))
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
            } else {
                Text("No description ...")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.7))
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 16)
    }
    
    private var mapView: some View {
        VStack {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 180)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 16)
            } else {
                Map(initialPosition: .region(viewModel.region), content: {
                    let event = viewModel.model.event
                    let coordinates = event.location.coordinates
                    
                    Marker(event.location.address, coordinate: CLLocationCoordinate2D(
                        latitude: coordinates.latitude,
                        longitude: coordinates.longitude
                    ))
                    .tint(.blue)
                })
                .frame(height: 180)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
    }
    
    private var participantsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 16)
            } else {
                HStack(spacing: 0) {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .offset(x: -10)
                    
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .offset(x: -20)
                    
                    Text("\(viewModel.participantCount) others joined")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.isJoined.toggle()
                    }) {
                        Image(systemName: viewModel.isJoined ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.isJoined ? .red : .black)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
    }
    
    private var joinButtonView: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding(.bottom, 32)
            } else {
                Button(action: {
                    if viewModel.isJoined {
                        viewModel.leaveEvent()
                    } else {
                        viewModel.joinEvent()
                        if let navigateToTicketPurchase = navigateToTicketPurchase {
                            navigateToTicketPurchase()
                        }
                    }
                }) {
                    Text(viewModel.isJoined ? "Leave Event" : viewModel.model.joinButtonText)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(viewModel.isJoined ? Color.red : Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                }
            }
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
