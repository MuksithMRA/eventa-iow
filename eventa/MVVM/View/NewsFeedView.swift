import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel()
    var navigateToHome: () -> Void
    var navigateToMap: (() -> Void)?
    
    init(navigateToHome: @escaping () -> Void, navigateToMap: (() -> Void)? = nil) {
        self.navigateToHome = navigateToHome
        self.navigateToMap = navigateToMap
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 16) {
                    sponsoredOrganizationsView
                    
                    postsView
                }
                .padding(.bottom, 16)
            }
            
            bottomTabBar
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.model.title)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
                    
                    Text("Colombo, Sri Lanka")
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
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var sponsoredOrganizationsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.model.sponsoredOrganizations) { organization in
                    OrganizationBubble(organization: organization) {
                        viewModel.followOrganization(organization)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    private var postsView: some View {
        VStack(spacing: 24) {
            ForEach(viewModel.model.posts) { post in
                PostCard(post: post, viewModel: viewModel)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            TabButton(title: "Home", icon: "house", selectedIcon: "house.fill", isSelected: viewModel.selectedTab == 0) {
                viewModel.selectedTab = 0
                navigateToHome()
            }
            
            TabButton(title: "Map", icon: "map", selectedIcon: "map.fill", isSelected: viewModel.selectedTab == 1) {
                viewModel.selectedTab = 1
                if let navigateToMap = navigateToMap {
                    navigateToMap()
                }
            }
            
            TabButton(title: "News Feed", icon: "newspaper", selectedIcon: "newspaper.fill", isSelected: viewModel.selectedTab == 2) {
                viewModel.selectedTab = 2
            }
            
            TabButton(title: "Profile", icon: "person", selectedIcon: "person.fill", isSelected: viewModel.selectedTab == 3) {
                viewModel.selectedTab = 3
            }
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
    }
}

struct OrganizationBubble: View {
    let organization: Organization
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 70, height: 70)
            
            Image(organization.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            if !organization.isFollowing {
                Button(action: action) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .offset(x: 25, y: 25)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .offset(x: 25, y: 25)
            }
        }
    }
}

struct PostCard: View {
    let post: Post
    let viewModel: NewsFeedViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(post.organization.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.organization.name)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(post.timePosted)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text(post.organization.isFollowing ? "Following" : "Follow")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(post.organization.isFollowing ? .gray : .blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(post.organization.isFollowing ? Color.gray.opacity(0.1) : Color.blue.opacity(0.1))
                        .cornerRadius(16)
                }
            }
            
            Text(post.content)
                .font(.system(size: 16))
                .lineSpacing(4)
            
            if !post.images.isEmpty {
                VStack(spacing: 2) {
                    ForEach(post.images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                            .cornerRadius(8)
                    }
                }
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.likePost(post)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: post.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .font(.system(size: 18))
                            .foregroundColor(post.isLiked ? .blue : .gray)
                        
                        Text(viewModel.formatCount(post.likes))
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                
                Button(action: {
                    viewModel.commentOnPost(post)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        Text("\(post.comments)")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                
                Button(action: {
                    viewModel.sharePost(post)
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrowshape.turn.up.right")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        Text("\(post.shares)")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
