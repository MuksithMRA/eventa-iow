import SwiftUI

struct TrialSubscriptionView: View {
    @StateObject private var viewModel = TrialSubscriptionViewModel()
    var navigateToHome: () -> Void
    
    init(navigateToHome: @escaping () -> Void) {
        self.navigateToHome = navigateToHome
    }
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.dismissSubscription()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                }
                
                Image("trophy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 10)
                
                Text(viewModel.model.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(viewModel.model.subtitle)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.model.features.indices, id: \.self) { index in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            Text(viewModel.model.features[index])
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                Button(action: {
                    viewModel.startFreeTrial()
                    navigateToHome()
                }) {
                    Text(viewModel.model.startButtonText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                Text(viewModel.model.subscriptionInfoText)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
    }
}

