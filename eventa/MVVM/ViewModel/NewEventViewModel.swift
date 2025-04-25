import Foundation
import SwiftUI
import Combine
import CoreLocation
import MapKit

class NewEventViewModel: ObservableObject {
    @Published var model: NewEventModel
    @Published var formData: EventFormData
    @Published var showLocationPicker: Bool = false
    @Published var showDatePicker: Bool = false
    @Published var showStartTimePicker: Bool = false
    @Published var showEndTimePicker: Bool = false
    @Published var showThemePicker: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.model = NewEventModel()
        self.formData = EventFormData()
    }
    
    func saveEvent(completion: @escaping () -> Void) {
        guard validateForm() else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        guard let token = TokenManager.shared.getToken() else {
            self.errorMessage = "You must be logged in to create an event"
            self.isLoading = false
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        var eventData: [String: Any] = [
            "title": formData.title,
            "description": formData.description,
            "date": dateFormatter.string(from: formData.date),
            "time": timeFormatter.string(from: formData.startTime),
            "price": [
                "amount": Double(formData.price) ?? 0,
                "currency": "LKR"
            ],
            "category": "Technology"
        ]
        
        if formData.isOffline {
            eventData["location"] = [
                "address": formData.location,
                "city": "Colombo",
                "coordinates": [
                    "latitude": formData.latitude,
                    "longitude": formData.longitude
                ]
            ]
        } else {
            eventData["location"] = [
                "address": formData.meetingLink,
                "city": "Online",
                "coordinates": [
                    "latitude": 0.0,
                    "longitude": 0.0
                ]
            ]
        }
        
        Task {
            do {
                let response = try await EventsAPI.shared.createEvent(token: token, eventData: eventData)
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion()
                }
            } catch let error as APIError {
                DispatchQueue.main.async {
                    self.errorMessage = error.message
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "An unknown error occurred"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func validateForm() -> Bool {
        if formData.title.isEmpty {
            errorMessage = "Please enter a title for your event"
            return false
        }
        
        if formData.description.isEmpty {
            errorMessage = "Please enter a description for your event"
            return false
        }
        
        if formData.isOffline {
            if formData.location.isEmpty {
                errorMessage = "Please select a location for your event"
                return false
            }
            
            if formData.latitude == 0.0 && formData.longitude == 0.0 {
                errorMessage = "Please select a valid location on the map"
                return false
            }
        } else {
            if formData.meetingLink.isEmpty {
                errorMessage = "Please enter a meeting link for your online event"
                return false
            }
        }
        
        if formData.price.isEmpty {
            errorMessage = "Please enter a price for your event"
            return false
        } else if Double(formData.price) == nil {
            errorMessage = "Please enter a valid price"
            return false
        }
        
        return true
    }
    
    func selectLocation() {
        showLocationPicker = true
    }
    
    func setLocation(name: String, latitude: Double, longitude: Double) {
        formData.location = name
        formData.latitude = latitude
        formData.longitude = longitude
    }
    
    func selectDate() {
        showDatePicker = true
    }
    
    func selectStartTime() {
        showStartTimePicker = true
    }
    
    func selectEndTime() {
        showEndTimePicker = true
    }
    
    func selectTheme() {
        showThemePicker = true
    }
    
    func toggleEventType() {
        formData.isOffline.toggle()
    }
}
