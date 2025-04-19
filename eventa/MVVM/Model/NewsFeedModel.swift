import Foundation
import SwiftUI

struct NewsFeedModel {
    let title: String
    let sponsoredOrganizations: [Organization]
    let posts: [Post]
}

struct Organization: Identifiable {
    let id = UUID()
    let name: String
    let logo: String
    let isFollowing: Bool
}

struct Post: Identifiable {
    let id = UUID()
    let organization: Organization
    let timePosted: String
    let content: String
    let images: [String]
    let hashtags: [String]
    let likes: Int
    let comments: Int
    let shares: Int
    let isLiked: Bool
}
