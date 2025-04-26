import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    var navigateToHome: () -> Void
    var navigateToNewsFeed: () -> Void
    
    init(navigateToHome: @escaping () -> Void, navigateToNewsFeed: @escaping () -> Void) {
        self.navigateToHome = navigateToHome
        self.navigateToNewsFeed = navigateToNewsFeed
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ZStack {
                mapContentView
                
                VStack {
                    Spacer()
                    nearbyEventsView
                }
                
                if viewModel.showEventDetails {
                    eventDetailsView
                }
            }
            
            bottomTabBar
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.model.title)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 14))
                        
                        Text(viewModel.userLocation)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 20))
                    
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField(viewModel.model.searchPlaceholder, text: $viewModel.searchQuery)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .onSubmit {
                            viewModel.searchEventsOnMap(query: viewModel.searchQuery)
                        }
                    
                    if !viewModel.searchQuery.isEmpty {
                        Button(action: {
                            viewModel.searchQuery = ""
                            viewModel.fetchEvents()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
    }
    
    private var mapContentView: some View {
        ZStack {
            Map(initialPosition: .region(viewModel.model.mapRegion)) {
                ForEach(viewModel.model.eventLocations) { location in
                    Annotation("", coordinate: location.coordinate) {
                        ZStack {
                            Circle()
                                .fill(location.color)
                                .frame(width: 36, height: 36)
                            Image(systemName: location.icon)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.viewEventDetails(location)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.fetchEvents()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                
                Spacer()
            }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if viewModel.showEventDetails {
                        viewModel.closeEventDetails()
                    }
                }
        }
    }
    
    private var nearbyEventsView: some View {
        VStack {
            if viewModel.isLoading && viewModel.model.eventLocations.isEmpty {
                ProgressView()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
            } else if viewModel.model.eventLocations.isEmpty {
                Text("No events found in this area")
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.model.eventLocations) { event in
                            EventCardMap(event: event) {
                                viewModel.viewEventDetails(event)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
            }
        }
    }
    
    private var eventDetailsView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModel.closeEventDetails()
                }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(viewModel.selectedEvent?.name ?? "")
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.closeEventDetails()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(viewModel.selectedEvent?.date ?? "")
                                .font(.system(size: 16))
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text(viewModel.selectedEvent?.time ?? "")
                                .font(.system(size: 16))
                        }
                        
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(.blue)
                            Text(String(format: "LKR %.2f", viewModel.selectedEvent?.price ?? 0))
                                .font(.system(size: 16))
                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(viewModel.selectedEvent?.color ?? .blue)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: viewModel.selectedEvent?.icon ?? "star")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                
                Divider()
                
                if let description = viewModel.selectedEvent?.description, !description.isEmpty {
                    Text("About Event")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text(description)
                        .font(.system(size: 16))
                        .lineLimit(4)
                    
                    Divider()
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    
                    Text("View on map")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
                .onTapGesture {
                    if let event = viewModel.selectedEvent {
                        viewModel.zoomToLocation(event.coordinate)
                        viewModel.closeEventDetails()
                    }
                }
                
                if viewModel.isLoading {
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(12)
                    }
                    .disabled(true)
                } else {
                    Button(action: {
                        viewModel.joinEvent()
                    }) {
                        Text("Join Event")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10)
            .padding(.horizontal, 24)
        }
    }
    
    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            TabButton(title: "Home", icon: "house", selectedIcon: "house.fill", isSelected: viewModel.selectedTab == 0) {
                viewModel.selectedTab = 0
                navigateToHome()
            }
            
            TabButton(title: "Map", icon: "map", selectedIcon: "map.fill", isSelected: viewModel.selectedTab == 1) {
                viewModel.selectedTab = 1
            }
            
            TabButton(title: "News Feed", icon: "newspaper", selectedIcon: "newspaper.fill", isSelected: viewModel.selectedTab == 2) {
                viewModel.selectedTab = 2
                navigateToNewsFeed()
            }
            
            TabButton(title: "Profile", icon: "person", selectedIcon: "person.fill", isSelected: viewModel.selectedTab == 3) {
                viewModel.selectedTab = 3
            }
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
    }
}

struct EventCardMap: View {
    let event: EventLocation
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.name)
                        .font(.system(size: 16, weight: .medium))
                        .lineLimit(1)
                    
                    Text(event.date)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text(String(format: "LKR %.2f", event.price))
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(event.color)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: event.icon)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
            }
            
            Button(action: action) {
                Text("View Details")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .frame(width: 240)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
