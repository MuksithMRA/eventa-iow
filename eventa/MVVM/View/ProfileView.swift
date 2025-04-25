import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    var navigateToHome: () -> Void
    var navigateToMap: () -> Void
    var navigateToNewsFeed: () -> Void
    var navigateToLogin: (() -> Void)?
    
    init(navigateToHome: @escaping () -> Void, navigateToMap: @escaping () -> Void, navigateToNewsFeed: @escaping () -> Void, navigateToLogin: (() -> Void)? = nil) {
        self.navigateToHome = navigateToHome
        self.navigateToMap = navigateToMap
        self.navigateToNewsFeed = navigateToNewsFeed
        self.navigateToLogin = navigateToLogin
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeaderView
                    
                    statsView
                    
                    if viewModel.isLoading {
                        subscriptionLoadingView
                    } else if viewModel.isPremiumUser {
                        premiumBadgeView
                    } else {
                        freeTrialBannerView
                    }
                    
                    upcomingEventsView
                    
                    menuListView
                }
                .padding(.bottom, 16)
            }
            
            bottomTabBar
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 16) {
            Image(viewModel.model.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 3)
                )
                .padding(.top, 24)
            
            Text(viewModel.model.userName)
                .font(.system(size: 24, weight: .bold))
            
            Text(viewModel.model.userEmail)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 14))
                
                Text(viewModel.model.userLocation)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Text(viewModel.model.userBio)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 8)
        }
    }
    
    private var statsView: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.model.statsItems) { item in
                VStack(spacing: 4) {
                    Text(item.value)
                        .font(.system(size: 20, weight: .bold))
                    
                    Text(item.title)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 16)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    private var premiumBadgeView: some View {
        HStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 32))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Premium Member")
                    .font(.system(size: 18, weight: .bold))
                
                if let expiryDate = viewModel.subscriptionExpiryDate {
                    let formattedDate = formatDate(expiryDate)
                    Text("Your subscription is active until \(formattedDate)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                } else {
                    Text("Your subscription is active")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    private var freeTrialBannerView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Upgrade to Premium")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("Get access to exclusive features and benefits")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(8)
            } else {
                Button(action: {
                    viewModel.startFreeTrial()
                }) {
                    Text("Start Free 14-Day Trial")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .disabled(viewModel.isLoading)
            }
            
//            if let errorMessage = viewModel.errorMessage {
//                Text(errorMessage)
//                    .font(.system(size: 14))
//                    .foregroundColor(.red)
//                    .padding(.top, 8)
//            }
        }
        .padding(16)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    private var subscriptionLoadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
                .padding(24)
            Spacer()
        }
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    private var upcomingEventsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Events")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.model.upcomingEvents) { event in
                        EventCard(event: event) {
                            viewModel.viewEventDetails(event)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var menuListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                ForEach(viewModel.model.menuItems) { item in
                    Button(action: {
                        if item.title == "Logout" {
                            viewModel.logout()
                            navigateToLogin?()
                        } else {
                            viewModel.handleMenuItemTap(item)
                        }
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                                .foregroundColor(item.title == "Logout" ? .red : .blue)
                                .frame(width: 24, height: 24)
                            
                            Text(item.title)
                                .font(.system(size: 16))
                                .foregroundColor(item.title == "Logout" ? .red : .primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                    }
                    
                    if item.id != viewModel.model.menuItems.last?.id {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 16)
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
                navigateToMap()
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

struct EventCard: View {
    let event: ProfileEvent
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(event.color)
                    .frame(height: 100)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                
                Text(event.date)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    
                    Text(event.time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    
                    Text(event.location)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
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
                .padding(.top, 4)
            }
            .padding(12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .frame(width: 240)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension ProfileView {
    func formatDate(_ isoDateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        
        if let date = dateFormatter.date(from: isoDateString) {
            return displayFormatter.string(from: date)
        }
        return isoDateString
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
