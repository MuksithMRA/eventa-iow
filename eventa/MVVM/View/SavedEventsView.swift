import SwiftUI
import Foundation

struct SavedEventsView: View {
    
    enum SavedEventsTab {
        case published
        case saved
    }
    
    @StateObject private var viewModel = SavedEventsViewModel()
    
    var navigateToHome: (() -> Void)?
    var navigateToEventDetails: ((EventItem) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            tabSelectionView
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    if viewModel.selectedTab == .saved {
                        ForEach(viewModel.currentEvents) { event in
                            savedEventCardView(event: event)
                                .onTapGesture {
                                    if let navigateToEventDetails = navigateToEventDetails {
                                        navigateToEventDetails(event)
                                    }
                                }
                        }
                    } else {
                        ForEach(viewModel.currentEvents) { event in
                            publishedEventCardView(event: event)
                                .onTapGesture {
                                    if let navigateToEventDetails = navigateToEventDetails {
                                        navigateToEventDetails(event)
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                if let navigateToHome = navigateToHome {
                    navigateToHome()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text(viewModel.model.title)
                .font(.system(size: 18, weight: .bold))
            
            Spacer()
            
            Spacer().frame(width: 24)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private var tabSelectionView: some View {
        HStack(spacing: 16) {
            Button(action: {
                viewModel.selectedTab = .published
            }) {
                Text(viewModel.model.publishedTabTitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(viewModel.selectedTab == .published ? .white : .blue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(viewModel.selectedTab == .published ? Color.blue : Color.blue.opacity(0.1))
                    .cornerRadius(20)
            }
            
            Button(action: {
                viewModel.selectedTab = .saved
            }) {
                Text(viewModel.model.savedTabTitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(viewModel.selectedTab == .saved ? .white : .black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(viewModel.selectedTab == .saved ? Color.black : Color.gray.opacity(0.1))
                    .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private func savedEventCardView(event: EventItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(event.color)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.unsaveEvent(event)
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(event.day)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(event.month)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 16)
                        
                        Text(event.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Spacer().frame(height: 8)
                        
                        Text("LKR \(event.price, specifier: "%.0f")")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 16)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            Text(event.location.address)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    if !event.image.isEmpty {
                        Image(event.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .padding(.trailing, 16)
                            .padding(.top, 16)
                    }
                }
                
                Spacer()
            }
            .frame(height: 180)
        }
    }
    
    private func publishedEventCardView(event: EventItem) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(event.color)
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            viewModel.editPublishedEvent(event)
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            viewModel.deletePublishedEvent(event)
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(event.day)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(event.month)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 16)
                        
                        Text(event.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Spacer().frame(height: 8)
                        
                        Text("LKR \(event.price, specifier: "%.0f")")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 16)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            Text(event.location.address)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    if !event.image.isEmpty {
                        Image(event.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .padding(.trailing, 16)
                            .padding(.top, 16)
                    }
                }
                
                Spacer()
            }
            .frame(height: 180)
        }
    }
}

struct SavedEventsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedEventsView()
    }
}
