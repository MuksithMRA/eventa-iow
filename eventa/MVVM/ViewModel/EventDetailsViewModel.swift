import Foundation
import SwiftUI
import MapKit

class EventDetailsViewModel: ObservableObject {
    @Published var model: EventDetailsModel
    @Published var isJoined: Bool = false
    @Published var participantCount: Int = 10
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
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
        
    }
    
    func openMap() {
        
    }
}
