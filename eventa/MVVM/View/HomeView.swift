import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var navigateToNewsFeed: () -> Void
    var navigateToMap: (() -> Void)?
    var navigateToProfile: () -> Void
    var navigateToNewEvent: (() -> Void)?
    var navigateToEventDetails: ((EventItem) -> Void)?
    var navigateToSavedEvents: (() -> Void)?
    
    init(navigateToNewsFeed: @escaping () -> Void, navigateToMap: (() -> Void)? = nil, navigateToProfile: @escaping () -> Void, navigateToNewEvent: (() -> Void)? = nil, navigateToEventDetails: ((EventItem) -> Void)? = nil, navigateToSavedEvents: (() -> Void)? = nil) {
        self.navigateToNewsFeed = navigateToNewsFeed
        self.navigateToMap = navigateToMap
        self.navigateToProfile = navigateToProfile
        self.navigateToNewEvent = navigateToNewEvent
        self.navigateToEventDetails = navigateToEventDetails
        self.navigateToSavedEvents = navigateToSavedEvents

        viewModel.navigateToNewEvent = navigateToNewEvent
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 24) {
                    actionButtonsView
                    
                    if !viewModel.searchQuery.isEmpty {
                        searchResultsView
                    } else {
                        featuredEventsView
                        
                        Text(viewModel.model.eventsForYouTitle)
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        eventsForYouView
                    }
                }
                .padding(.bottom, 16)
            }
            
            bottomTabBar
        }
        .onChange(of: viewModel.searchQuery) { newValue in
            if !newValue.isEmpty {
                viewModel.searchEvents(query: newValue)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.model.currentLocationTitle)
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
                            viewModel.searchEvents(query: viewModel.searchQuery)
                        }
                    
                    if !viewModel.searchQuery.isEmpty {
                        Button(action: {
                            viewModel.searchQuery = ""
                            viewModel.searchResults = []
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
    
    private var actionButtonsView: some View {
        HStack(spacing: 0) {
            Button(action: {
                navigateToNewEvent?()
            }) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Text("Post\nEvent")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                navigateToSavedEvents?()
            }) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 44, height: 44)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemName: "heart")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    
                    Text("Saved\nEvents")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                viewModel.viewCategory()
            }) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 44, height: 44)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    
                    Text("Category")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                viewModel.viewNotifications()
            }) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 44, height: 44)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 12, y: -12)
                    }
                    
                    Text("Notification")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    private var featuredEventsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                if viewModel.isLoading && viewModel.featuredEvents.isEmpty {
                    ProgressView()
                        .frame(width: 280, height: 180)
                } else if viewModel.featuredEvents.isEmpty {
                    Text("No featured events available")
                        .frame(width: 280, height: 180)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                } else {
                    ForEach(viewModel.featuredEvents) { event in
                        FeaturedEventCard(event: event) {
                            navigateToEventDetails?(event)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var eventsForYouView: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading && viewModel.upcomingEvents.isEmpty {
                ProgressView()
                    .frame(height: 100)
            } else if viewModel.upcomingEvents.isEmpty {
                Text("No events found")
                    .frame(height: 100)
            } else {
                ForEach(viewModel.upcomingEvents) { event in
                    EventListItem(event: event) {
                        navigateToEventDetails?(event)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var searchResultsView: some View {
        VStack(spacing: 16) {
            Text("Search Results")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            if viewModel.isSearching {
                ProgressView()
                    .frame(height: 100)
            } else if viewModel.searchResults.isEmpty {
                Text("No results found")
                    .frame(height: 100)
                    .padding(.horizontal, 16)
            } else {
                ForEach(viewModel.searchResults) { event in
                    EventListItem(event: event) {
                        navigateToEventDetails?(event)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            TabButton(title: "Home", icon: "house", selectedIcon: "house.fill", isSelected: viewModel.selectedTab == 0) {
                viewModel.selectedTab = 0
            }
            
            TabButton(title: "Map", icon: "map", selectedIcon: "map.fill", isSelected: viewModel.selectedTab == 1) {
                viewModel.selectedTab = 1
                if let navigateToMap = navigateToMap {
                    navigateToMap()
                }
            }
            
            TabButton(title: "News Feed", icon: "newspaper", selectedIcon: "newspaper.fill", isSelected: viewModel.selectedTab == 2) {
                viewModel.selectedTab = 2
                navigateToNewsFeed()
            }
            
            TabButton(title: "Profile", icon: "person", selectedIcon: "person.fill", isSelected: viewModel.selectedTab == 3) {
                viewModel.selectedTab = 3
                navigateToProfile()

            }
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
    }
}

struct FeaturedEventCard: View {
    let event: EventItem
    let action: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(event.color)
                .frame(width: 280, height: 180)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(event.day)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(event.month)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    if event.image.count > 0 {
                        Image(event.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                }
                
                Text(event.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                HStack {
                    Image(systemName: "location.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    Text(event.location.address)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(.top, 4)
            }
            .padding(16)
        }
    }
}

struct EventListItem: View {
    let event: EventItem
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Text(event.month)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(event.day)
                    .font(.system(size: 24, weight: .bold))
            }
            .frame(width: 60, height: 60)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 16, weight: .medium))
                
                Text(event.timeRange)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(event.location.address)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: action) {
                Text(event.joinButtonText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
