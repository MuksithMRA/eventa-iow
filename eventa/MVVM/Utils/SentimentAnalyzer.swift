import Foundation
import NaturalLanguage
import SwiftUI

class SentimentAnalyzer {
    static let shared = SentimentAnalyzer()
    
    private init() {}
    
    enum SentimentType: String {
        case positive
        case negative
    }
    
    func analyzeSentiment(for text: String) -> SentimentType {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        if let sentiment = sentiment, let score = Double(sentiment.rawValue) {
            return score >= 0 ? .positive : .negative
        }
        
        return .positive
    }
    
    func analyzeSentimentWithConfidence(for text: String) -> (type: SentimentType, confidence: Double) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        if let sentiment = sentiment, let score = Double(sentiment.rawValue) {
            let normalizedScore = (score + 1) / 2
            let confidence = abs(normalizedScore - 0.5) * 2
            return (score >= 0 ? .positive : .negative, confidence)
        }
        
        return (.positive, 0.5)
    }
}
