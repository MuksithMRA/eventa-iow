import Foundation
import SwiftUI
import MapKit
import Combine
import NaturalLanguage

enum ReviewType: String, CaseIterable {
    case positive
    case negative
}

struct Review: Identifiable {
    let id: String
    let userName: String
    let userImage: String
    let content: String
    let rating: Int
    let date: String
    let type: ReviewType
}

class EventDetailsViewModel: ObservableObject {
    private let sentimentTagger = NLTagger(tagSchemes: [.sentimentScore])
    
    private func analyzeSentiment(for text: String) -> ReviewType {
        sentimentTagger.string = text
        let (sentiment, _) = sentimentTagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        if let sentiment = sentiment, let score = Double(sentiment.rawValue) {
            return score >= 0 ? .positive : .negative
        }
        
        return .positive
    }
    
    private func analyzeSentimentWithConfidence(for text: String) -> (type: ReviewType, confidence: Double) {
        sentimentTagger.string = text
        let (sentiment, _) = sentimentTagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        if let sentiment = sentiment, let score = Double(sentiment.rawValue) {
            let normalizedScore = (score + 1) / 2
            let confidence = abs(normalizedScore - 0.5) * 2
            return (score >= 0 ? .positive : .negative, confidence)
        }
        
        return (.positive, 0.5)
    }
    @Published var model: EventDetailsModel
    @Published var isJoined: Bool = false
    @Published var participantCount: Int = 10
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var reviews: [Review] = []
    @Published var isLoadingReviews: Bool = false
    @Published var hasUserReviewed: Bool = false
    @Published var reviewContent: String = ""
    @Published var reviewRating: Int = 5
    @Published var selectedReviewType: ReviewType = .positive
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    init(event: EventItem) {
        self.model = EventDetailsModel(event: event)
        let coordinates = event.location.coordinates
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
        }
    }
    
    func joinEvent() {
        if !isJoined {
            isJoined = true
            participantCount += 1
        }
    }
    
    func leaveEvent() {
        if isJoined {
            isJoined = false
            participantCount -= 1
        }
    }
    
    func shareEvent() {
        
    }
    
    func openReviews() {
        loadReviews()
    }
    
    func openMap() {
        
    }
    
    
    func loadReviews(type: ReviewType? = nil) {
        isLoadingReviews = true
        errorMessage = ""
        
        guard let token = TokenManager.shared.getToken() else {
            self.errorMessage = "You need to be logged in to view reviews"
            self.isLoadingReviews = false
            return
        }
        
        let eventId = model.event.id;
        
        if eventId.isEmpty {
            self.errorMessage = "Event ID not found"
            self.isLoadingReviews = false
            return
        }
        
        Task {
            do {
                let typeString = type?.rawValue
                
                let response = try await EventsAPI.shared.getEventReviews(
                    token: token, 
                    eventId: eventId, 
                    type: typeString
                )
                
                await MainActor.run {
                    self.reviews = response.data.reviews.map { apiReview in
                        Review(
                            id: apiReview.id,
                            userName: apiReview.user.fullName,
                            userImage: "profile", // Using default image as API might not have images
                            content: apiReview.content,
                            rating: apiReview.rating,
                            date: Date().ISO8601Format(),
                            type: ReviewType(rawValue: apiReview.type) ?? .positive
                        )
                    }
                    
                    if let currentUserId = TokenManager.shared.getUserId() {
                        self.hasUserReviewed = response.data.reviews.contains { $0.user.id == currentUserId }
                    }
                    
                    self.isLoadingReviews = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load reviews: \(error.localizedDescription)"
                    self.isLoadingReviews = false
                }
            }
        }
    }
    
    func submitReview() {
        guard !reviewContent.isEmpty else {
            errorMessage = "Please enter review content"
            return
        }
        
        guard let token = TokenManager.shared.getToken() else {
            self.errorMessage = "You need to be logged in to submit a review"
            return
        }
        
        let eventId = model.event.id;
        
        if eventId.isEmpty {
            self.errorMessage = "Event ID not found"
            return
        }
        
        isLoadingReviews = true
        errorMessage = ""
        
        let sentimentResult = analyzeSentimentWithConfidence(for: reviewContent)
        let predictedType = sentimentResult.type
        let confidence = sentimentResult.confidence
        
        let reviewData: [String: Any] = [
            "content": reviewContent,
            "rating": reviewRating,
            "type": predictedType.rawValue,
            "confidence": confidence
        ]
        
        Task {
            do {
                let response = try await EventsAPI.shared.createReview(
                    token: token, 
                    eventId: eventId, 
                    reviewData: reviewData
                )
                
                await MainActor.run {
                    let apiReview = response.data.review
                    let newReview = Review(
                        id: apiReview.id,
                        userName: "You",
                        userImage: "profile",
                        content: apiReview.content,
                        rating: apiReview.rating,
                        date: "Just now",
                        type: ReviewType(rawValue: apiReview.type) ?? .positive
                    )
                    
                    self.reviews.insert(newReview, at: 0)
                    self.reviewContent = ""
                    self.reviewRating = 5
                    self.hasUserReviewed = true
                    self.isLoadingReviews = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to submit review: \(error.localizedDescription)"
                    self.isLoadingReviews = false
                }
            }
        }
    }
}
