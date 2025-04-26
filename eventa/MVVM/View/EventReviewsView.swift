import SwiftUI

struct EventReviewsView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: EventDetailsViewModel
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
                    viewModel.loadReviews(type: .positive)
                }) {
                    Text("Positive")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedReviewType == .positive ? .white : .blue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(selectedReviewType == .positive ? Color.blue : Color.blue.opacity(0.1))
                        .cornerRadius(20)
                }
                
                Button(action: {
                    selectedReviewType = .negative
                    viewModel.loadReviews(type: .negative)
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
            
            VStack(spacing: 16) {
                TextField("Write your review...", text: $viewModel.reviewContent)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                HStack {
                    Text("Rating:")
                        .font(.system(size: 16))

                    Picker("Rating", selection: $viewModel.reviewRating) {
                        ForEach(1...5, id: \.self) { rating in
                            Text("\(rating)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Button(action: {
                    viewModel.submitReview()
                }) {
                    Text("Submit Review")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            if viewModel.isLoadingReviews {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 20)
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(viewModel.reviews) { review in
                            reviewCard(review: review)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private func reviewCard(review: Review) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(review.userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.userName)
                        .font(.system(size: 16, weight: .medium))
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(index < review.rating ? .yellow : .gray)
                        }
                        
                        Text(review.date)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                    }
                }
            }
            
            Text(review.content)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.8))
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}
