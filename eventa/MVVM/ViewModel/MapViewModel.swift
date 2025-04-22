import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var model = MapModel()
    @Published var selectedTab: Int = 1
    @Published var selectedEvent: EventLocation?
    @Published var showEventDetails: Bool = false
    @Published var userLocation: String = "Colombo, Sri Lanka"
    
    func viewEventDetails(_ event: EventLocation) {
        selectedEvent = event
        showEventDetails = true
    }
    
    func closeEventDetails() {
        showEventDetails = false
        selectedEvent = nil
    }
    
    func joinEvent() {
        if let event = selectedEvent {
            print("Joined event: \(event.name)")
            closeEventDetails()
        }
    }
    
    func zoomToLocation(_ coordinate: CLLocationCoordinate2D) {
        model.mapRegion = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    func resetMapView() {
        model.mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    func getScreenPoint(for coordinate: CLLocationCoordinate2D) -> CGPoint? {
        // This is a placeholder implementation since we can't actually convert map coordinates to screen coordinates
        // In a real implementation, we would need to use a MKMapView and convert the coordinates
        // For now, we'll just return nil, which will hide the annotations
        return nil
    }
}
