import SwiftUI
import Combine

struct ContentView: View {
    @State private var currentView: AppView = .welcome
    
    enum AppView {
        case welcome
        case login
        case register
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
                    RegisterView(navigateToLogin: { currentView = .login })
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
