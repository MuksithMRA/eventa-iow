import SwiftUI
import Combine
import MapKit



struct ContentView: View {
    @State private var currentView: AppView = .welcome
    
    enum AppView {
        case welcome
        case login
        case register
        case trialSubscription
        case home
        case newsFeed
        case map
        case profile
        case newEvent
        case eventDetails(EventItem)
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
                    HomeView(
                        navigateToNewsFeed: { currentView = .newsFeed },
                        navigateToMap: { currentView = .map }, 
                        navigateToProfile: { currentView = .profile },
                        navigateToNewEvent: { currentView = .newEvent },
                        navigateToEventDetails: { event in currentView = .eventDetails(event) }
                    )
                case .newsFeed:
                    NewsFeedView(
                        navigateToHome: { currentView = .home },
                        navigateToMap: { currentView = .map }
                    )
                case .map:
                    MapView(
                        navigateToHome: { currentView = .home }, 
                        navigateToNewsFeed: { currentView = .newsFeed }
                    )
                case .profile:
                    ProfileView(
                        navigateToHome: { currentView = .home },
                        navigateToMap: { currentView = .map },
                        navigateToNewsFeed: { currentView = .newsFeed }
                    )
                case .newEvent:
                    NewEventView(onDismiss: { currentView = .home })
                case .eventDetails(let event):
                    EventDetailsView(event: event)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
