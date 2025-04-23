import Foundation
import SwiftUI

class WelcomeViewModel: ObservableObject {
    @Published var model: WelcomeModel
    
    init() {
        self.model = WelcomeModel(
            title: "Welcome to Eventa",
            description: "Discover exciting events around you with ease. From concerts to workshops, never miss out on what's happening. Customize your interests, explore nearby events, and book tickets seamlessly",
            buttonText: "Let's Get Started"
        )
    }
    
    func getStarted() {
        
    }
}
