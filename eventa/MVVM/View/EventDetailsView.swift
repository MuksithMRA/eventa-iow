import SwiftUI
import MapKit

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(event: EventItem) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(event: event))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content structure
            VStack(spacing: 0) {
                // Fixed header at the top
                headerView
                
                // Scrollable content below the header
                ScrollView {
                    // Content starts with padding to avoid overlapping with header
                    VStack(spacing: 0) {
                        // This spacer ensures the content starts below the blue header
                        Spacer().frame(height: 30)
                        
                        // Participants section moved to top as shown in the design
                        participantsView
                        
                        eventDescriptionView
                        
                        mapView
                    }
                    .padding(.top, 20) // Additional top padding for the scroll content
                }
            }
            
            // Fixed button at the bottom
            joinButtonView
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerView: some View {
        ZStack {
            // Blue background that fills the header area
            Color.blue
            
            // Header content
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.openReviews()
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
        .zIndex(1) // Ensure header stays on top
    }
    
    // Removed eventInfoView as it's no longer needed
    
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
