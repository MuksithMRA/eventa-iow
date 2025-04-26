import MapKit
import SwiftUI
import Combine

struct EventDetailsView: View {
    @StateObject private var viewModel: EventDetailsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showReviews: Bool = false
    @State private var selectedReviewType: ReviewType = .positive
    var navigateToHome: (() -> Void)?
    var navigateToTicketPurchase: (() -> Void)?

    init(
        event: EventItem, navigateToHome: (() -> Void)? = nil,
        navigateToTicketPurchase: (() -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(event: event))
        self.navigateToHome = navigateToHome
        self.navigateToTicketPurchase = navigateToTicketPurchase
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                headerView
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 30)

                        participantsView

                        eventDescriptionView

                        mapView

                        Spacer().frame(height: 100)
                    }
                    .padding(.top, 20)
                }
            }

            joinButtonView
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showReviews) {
            EventReviewsView(isPresented: $showReviews, viewModel: viewModel)
        }
    }

    private var headerView: some View {
        ZStack {
            Color.blue

            Image(viewModel.model.event.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 280)
                .opacity(0.2)

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        if let navigateToHome = navigateToHome {
                            navigateToHome()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Button(action: {
                            showReviews = true
                        }) {
                            Text("Reviews")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    if !viewModel.isLoading {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.model.event.day)
                                .font(.system(size: 32))
                                .foregroundColor(.white)

                            Text(viewModel.model.event.month)
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 12)

                        Text(viewModel.model.event.title)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding(.bottom, 12)
                        
                        Text(viewModel.model.event.price == 0 ? "Free":"LKR \(String(format: "%.0f", viewModel.model.event.price))")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.bottom, 16)

                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)

                            Text(viewModel.model.event.location.address)
                                .font(.system(size: 18))
                                .foregroundColor(.white)

                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .frame(height: 280)
        .zIndex(1)
    }

    private var eventDescriptionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Description")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 16)
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 20)
            } else if viewModel.model.event.description.isEmpty {
                Text("No description ...")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.7))
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            } else {
                Text(viewModel.model.event.description)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.7))
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }
        }
        .padding(.vertical, 16)
    }

    var mapView: some View {
        VStack {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 180)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 16)
            } else {
                Map(
                    initialPosition: .region(viewModel.region),
                    content: {
                        let event = viewModel.model.event
                        let coordinates = event.location.coordinates

                        Marker(
                            event.location.address,
                            coordinate: CLLocationCoordinate2D(
                                latitude: coordinates.latitude,
                                longitude: coordinates.longitude
                            )
                        )
                        .tint(.blue)
                    }
                )
                .frame(height: 180)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
    }

    private var participantsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 16)
            } else {
                HStack(spacing: 0) {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())

                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .offset(x: -10)

                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .offset(x: -20)

                    Text("\(viewModel.participantCount) others joined")
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.leading, 8)

                    Spacer()

                    Button(action: {
                        viewModel.isJoined.toggle()
                    }) {
                        Image(systemName: viewModel.isJoined ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.isJoined ? .red : .black)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
    }

   private var joinButtonView: some View {
        VStack {
            if viewModel.isLoading {
                let progressStyle = CircularProgressViewStyle(tint: .blue)
                ProgressView()
                    .progressViewStyle(progressStyle)
                    .padding(.bottom, 32)
            } else {
                Button(action: {
                    if viewModel.isJoined {
                        viewModel.leaveEvent()
                    } else {
                        viewModel.joinEvent()
                        if let navigateToTicketPurchase = navigateToTicketPurchase {
                            navigateToTicketPurchase()
                        }
                    }
                }) {
                    Text(viewModel.isJoined ? "Leave Event" : viewModel.model.joinButtonText)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(viewModel.isJoined ? Color.red : Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                }
            }
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
