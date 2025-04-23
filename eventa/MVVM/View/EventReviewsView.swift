import SwiftUI

struct EventReviewsView: View {
    @Binding var isPresented: Bool
    @State private var selectedReviewType: ReviewType = .positive
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Reviews")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            HStack(spacing: 16) {
                Button(action: {
                    selectedReviewType = .positive
                }) {
                    Text("Postive")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedReviewType == .positive ? .white : .blue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(selectedReviewType == .positive ? Color.blue : Color.blue.opacity(0.1))
                        .cornerRadius(20)
                }
                
                Button(action: {
                    selectedReviewType = .negative
                }) {
                    Text("Negative")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedReviewType == .negative ? .white : .black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(selectedReviewType == .negative ? Color.black : Color.gray.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(0..<3) { _ in
                        reviewCard
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
    }
    
    private var reviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Jake Willson")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Cyber Security enthusiast")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Text("A must-attend for cybersecurity pros!")
                .font(.system(size: 16, weight: .medium))
            
            Text("This was an incredible experience! The live hacking demos were eye-opening, and the expert panels provided real-world insights. Can't wait for next year!")
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.7))
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

enum ReviewType {
    case positive
    case negative
}
