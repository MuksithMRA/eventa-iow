import Foundation
import SwiftUI
import Combine

class TrialSubscriptionViewModel: ObservableObject {
    @Published var model: TrialSubscriptionModel
    
    init() {
        self.model = TrialSubscriptionModel(
            title: "Enjoy your 14 days free trial",
            subtitle: "No payment now - Cancel anytime",
            features: [
                "20 events per month",
                "Online Payment handeling",
                "Monthly / Weekly reports",
                "Advanced analytics",
                "Ticket Templates",
                "Promote event twice per month"
            ],
            startButtonText: "Start free 14 days trial",
            subscriptionInfoText: "Your subscription starts after the trial, When you'll be charged LKR 3000 Per month",
            monthlyPrice: "3000"
        )
    }
    
    func startFreeTrial() {
        
    }
    
    func dismissSubscription() {
        
    }
}
