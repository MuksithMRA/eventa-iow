import SwiftUI
import Combine

struct ContentView: View {
    @State private var currentView: AppView = .welcome
    
    enum AppView {
        case welcome
        case login
        case register
        case trialSubscription
        case home
        case newsFeed
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                switch currentView {
                case .welcome:
                    WelcomeView(navigateToLogin: { currentView = .register })
                case .login:
                    LoginView()
                case .register:
                    RegisterView(navigateToLogin: { currentView = .login }, onRegistrationComplete: { currentView = .trialSubscription })
                case .trialSubscription:
                    TrialSubscriptionView(navigateToHome: { currentView = .home })
                case .home:
                    HomeView(navigateToNewsFeed: { currentView = .newsFeed })
                case .newsFeed:
                    NewsFeedView(navigateToHome: { currentView = .home })
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
