import Foundation
import SwiftUI
import Combine

class NewEventViewModel: ObservableObject {
    @Published var model: NewEventModel
    @Published var formData: EventFormData
    @Published var showLocationPicker: Bool = false
    @Published var showDatePicker: Bool = false
    @Published var showStartTimePicker: Bool = false
    @Published var showEndTimePicker: Bool = false
    @Published var showThemePicker: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.model = NewEventModel()
        self.formData = EventFormData()
    }
    
    func saveEvent(completion: @escaping () -> Void) {

        completion()
    }
    
    func selectLocation() {
        showLocationPicker = true
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
