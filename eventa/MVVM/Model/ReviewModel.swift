import Foundation


struct ReviewModel: Identifiable {
    let id: String
    let content: String
    let rating: Int
    let type: ReviewType
    let user: UserModel
    let createdAt: Date
    
    init(id: String, content: String, rating: Int, type: ReviewType, user: UserModel, createdAt: Date) {
        self.id = id
        self.content = content
        self.rating = rating
        self.type = type
        self.user = user
        self.createdAt = createdAt
    }
}

struct UserModel: Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let profileImage: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}
