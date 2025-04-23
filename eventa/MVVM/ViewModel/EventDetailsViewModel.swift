import Foundation
import SwiftUI

class EventDetailsViewModel: ObservableObject {
    @Published var model: EventDetailsModel
    @Published var isJoined: Bool = false
    @Published var participantCount: Int = 10
    
    init(event: EventItem) {
        self.model = EventDetailsModel(event: event)
    }
    
    func joinEvent() {
        isJoined.toggle()
        if isJoined {
            participantCount += 1
        } else {
            participantCount -= 1
        }
    }
    
    func shareEvent() {
        
    }
    
    func openReviews() {
        
    }
    
    func openMap() {
        
    }
}
