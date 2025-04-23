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
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        if let navigateToHome = navigateToHome {
                            navigateToHome()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showReviews = true
                    }) {
                        Text(viewModel.model.reviewsButtonText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.model.event.day)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(viewModel.model.event.month)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        if !viewModel.model.event.image.isEmpty {
                            Image(viewModel.model.event.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                        }
                    }
                    
                    Text(viewModel.model.event.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("LKR 1000")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewModel.openMap()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Text(viewModel.model.event.location)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
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
                
            Text("Join top cybersecurity experts at CyberShield 2025, the ultimate conference on threat intelligence, ethical hacking, and AI-driven security. Explore live hacking demos, hands-on workshops, and keynote sessions from industry leaders. Whether you're a pro or just starting, this event equips you with the latest tools to defend against cyber threats.")
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.7))
                .lineSpacing(4)
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
    }
    
    private var mapView: some View {
        VStack {
            Map(initialPosition: .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))) {
                Marker("Event Location", coordinate: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612))
                    .tint(.blue)
            }
            .frame(height: 180)
            .cornerRadius(12)
            .padding(.horizontal, 16)
        }
    }
    
    private var participantsView: some View {
        VStack(alignment: .leading, spacing: 16) {
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
    
    private var joinButtonView: some View {
        VStack {
            Button(action: {
                viewModel.joinEvent()
                if let navigateToTicketPurchase = navigateToTicketPurchase {
                    navigateToTicketPurchase()
                }
            }) {
                Text(viewModel.model.joinButtonText)
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
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
