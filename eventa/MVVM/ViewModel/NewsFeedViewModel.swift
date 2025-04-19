import Foundation
import SwiftUI
import Combine

class NewsFeedViewModel: ObservableObject {
    @Published var model: NewsFeedModel
    @Published var selectedTab: Int = 2
    
    init() {
        let gdgOrg = Organization(
            name: "GDG Sri Lanka",
            logo: "gdg_logo",
            isFollowing: true
        )
        
        let dialogOrg = Organization(
            name: "Dialog",
            logo: "dialog_logo",
            isFollowing: false
        )
        
        let googleOrg = Organization(
            name: "Google",
            logo: "google_logo",
            isFollowing: false
        )
        
        self.model = NewsFeedModel(
            title: "Current Location",
            sponsoredOrganizations: [googleOrg, dialogOrg, gdgOrg],
            posts: [
                Post(
                    organization: gdgOrg,
                    timePosted: "2 days ago",
                    content: "Epic talks, hands-on coding, and great connections! 🇱🇰\nWho's ready to build something awesome? 💪 #GDGDevFest #TechMagic",
                    images: ["devfest1", "devfest2"],
                    hashtags: ["GDGDevFest", "TechMagic"],
                    likes: 1000,
                    comments: 506,
                    shares: 5,
                    isLiked: false
                ),
                Post(
                    organization: gdgOrg,
                    timePosted: "5 days ago",
                    content: "Join us for an exciting developer meetup this weekend!",
                    images: ["meetup"],
                    hashtags: ["GDGMeetup", "Developers"],
                    likes: 450,
                    comments: 32,
                    shares: 12,
                    isLiked: true
                )
            ]
        )
    }
    
    func followOrganization(_ organization: Organization) {
        // Handle following organization
    }
    
    func likePost(_ post: Post) {
        // Handle liking post
    }
    
    func commentOnPost(_ post: Post) {
        // Handle commenting on post
    }
    
    func sharePost(_ post: Post) {
        // Handle sharing post
    }
    
    func formatCount(_ count: Int) -> String {
        if count >= 1000 {
            let formattedCount = Double(count) / 1000.0
            return "\(Int(formattedCount))k"
        }
        return "\(count)"
    }
}
