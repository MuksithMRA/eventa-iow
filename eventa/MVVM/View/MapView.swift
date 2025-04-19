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
                    
                    Text(viewModel.model.searchPlaceholder)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Spacer()
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
        Map(coordinateRegion: $viewModel.model.mapRegion, annotationItems: viewModel.model.eventLocations) { location in
            MapAnnotation(coordinate: location.coordinate) {
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
        .edgesIgnoringSafeArea(.all)
    }
    
    private var nearbyEventsView: some View {
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
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
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
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(viewModel.selectedEvent?.color ?? .blue)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: viewModel.selectedEvent?.icon ?? "")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                
                Divider()
                
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
