import SwiftUI
import Combine
import MapKit

struct ContentView: View {
    @State private var currentView: AppView
    
    init() {
        let initialView: AppView = ContentView.determineInitialView()
        _currentView = State(initialValue: initialView)
    }
    
    static func determineInitialView() -> AppView {
        let userDefaults = UserDefaults.standard
        let isFirstLaunch = !userDefaults.bool(forKey: "hasLaunchedBefore")
        
        if isFirstLaunch {
            userDefaults.set(true, forKey: "hasLaunchedBefore")
            return .welcome
        } else if isUserLoggedIn() {
            return .home
        } else {
            return .login
        }
    }
    
    static func isUserLoggedIn() -> Bool {
        if let tokenManagerClass = NSClassFromString("TokenManager") as? NSObject.Type,
           let sharedInstance = tokenManagerClass.value(forKey: "shared") as? NSObject {
            
            let selector = NSSelectorFromString("isLoggedIn")
            if sharedInstance.responds(to: selector) {
                let result = sharedInstance.perform(selector)
                if let isLoggedIn = result?.takeUnretainedValue() as? Bool {
                    return isLoggedIn
                }
            }
        }
        return false
    }
    
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
        case savedEvents
        case ticketPurchase(EventItem)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                switch currentView {
                case .welcome:
                    WelcomeView(navigateToLogin: { currentView = .register })
                case .login:
                    LoginView(
                        navigateToHome: { currentView = .home },
                        navigateToRegister: { currentView = .register }
                    )
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
                        navigateToEventDetails: { event in currentView = .eventDetails(event) },
                        navigateToSavedEvents: { currentView = .savedEvents }
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
                        navigateToNewsFeed: { currentView = .newsFeed },
                        navigateToLogin: { currentView = .login }
                    )
                case .newEvent:
                    NewEventView(onDismiss: { currentView = .home })
                case .eventDetails(let event):
                    EventDetailsView(
                        event: event, 
                        navigateToHome: { currentView = .home },
                        navigateToTicketPurchase: { currentView = .ticketPurchase(event) }
                    )
                    
                case .savedEvents:
                    SavedEventsView(
                        navigateToHome: { currentView = .home },
                        navigateToEventDetails: { event in
                            currentView = .eventDetails(event)
                        }
                    )
                    
                case .ticketPurchase(let event):
                    TicketPurchaseView(
                        event: event,
                        navigateToHome: { currentView = .home }
                    )
                }
            }
            .navigationBarHidden(true)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UserDidLogout"))) { _ in
                DispatchQueue.main.async {
                    self.currentView = .login
                }
            }

        }
    }
}

#Preview {
    ContentView()
}
