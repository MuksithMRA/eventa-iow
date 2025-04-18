import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    var navigateToLogin: () -> Void
    
    init(navigateToLogin: @escaping () -> Void) {
        self.navigateToLogin = navigateToLogin
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image("onboarding")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(.bottom, 40)
            
            Text(viewModel.model.title)
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 16)
            
            Text(viewModel.model.description)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                viewModel.getStarted()
                navigateToLogin()
            }) {
                Text(viewModel.model.buttonText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            
            Rectangle()
                .frame(width: 80, height: 4)
                .cornerRadius(2)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.bottom, 40)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
