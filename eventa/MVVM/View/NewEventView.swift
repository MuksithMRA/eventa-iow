import SwiftUI
import Combine
import MapKit

struct NewEventView: View {
    @StateObject private var viewModel = NewEventViewModel()
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                VStack(spacing: 24) {
                    titleField
                    
                    eventTypeToggle
                    
                    hostedBySection
                    
                    locationSection
                    
                    dateSection
                    
                    startTimeSection
                    
                    endTimeSection
                    
                    descriptionField
                    
                    themeSection
                    
                    priceSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
            }
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                loadingView
            }
            
            if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                onDismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text(viewModel.model.title)
                .font(.system(size: 18, weight: .medium))
            
            Spacer()
            
            Button(action: {
                viewModel.saveEvent {
                    onDismiss()
                }
            }) {
                Text(viewModel.model.saveButtonText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.system(size: 16, weight: .medium))
            
            TextField(viewModel.model.titlePlaceholder, text: $viewModel.formData.title)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
        }
    }
    
    private var eventTypeToggle: some View {
        HStack(spacing: 16) {
            Button(action: {
                if !viewModel.formData.isOffline {
                    viewModel.toggleEventType()
                }
            }) {
                Text(viewModel.model.offlineText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(viewModel.formData.isOffline ? .white : .black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(viewModel.formData.isOffline ? Color.blue : Color.white)
                    .cornerRadius(24)
            }
            
            Button(action: {
                if viewModel.formData.isOffline {
                    viewModel.toggleEventType()
                }
            }) {
                Text(viewModel.model.onlineText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(viewModel.formData.isOffline ? .black : .white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(viewModel.formData.isOffline ? Color.white : Color.blue)
                    .cornerRadius(24)
            }
            
            Spacer()
        }
    }
    
    private var hostedBySection: some View {
        HStack {
            Text(viewModel.model.hostedByText)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(viewModel.formData.hostImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                
                Text(viewModel.formData.hostName)
                    .font(.system(size: 16))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.model.locationText)
                .font(.system(size: 16, weight: .medium))
            
            if viewModel.formData.isOffline {
                HStack {
                    if viewModel.formData.location.isEmpty {
                        Text("No location selected")
                            .foregroundColor(.gray)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.formData.location)
                                .font(.system(size: 14))
                            
                            Text("Lat: \(String(format: "%.4f", viewModel.formData.latitude)), Long: \(String(format: "%.4f", viewModel.formData.longitude))")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.selectLocation()
                    }) {
                        Text(viewModel.model.selectFromMapText)
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .sheet(isPresented: $viewModel.showLocationPicker) {
                    MapLocationPickerView(viewModel: viewModel)
                }
            } else {
                TextField("Enter meeting link", text: $viewModel.formData.meetingLink)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
            }
        }
    }
    
    private var dateSection: some View {
        HStack {
            Text(viewModel.model.dateText)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Button(action: {
                viewModel.selectDate()
            }) {
                Text(viewModel.model.selectFromCalendarText)
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var startTimeSection: some View {
        HStack {
            Text(viewModel.model.startTimeText)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Button(action: {
                viewModel.selectStartTime()
            }) {
                Text(viewModel.model.selectFromPickerText)
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var endTimeSection: some View {
        HStack {
            Text(viewModel.model.endTimeText)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Button(action: {
                viewModel.selectEndTime()
            }) {
                Text(viewModel.model.selectFromPickerText)
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.system(size: 16, weight: .medium))
            
            TextEditor(text: $viewModel.formData.description)
                .frame(height: 150)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var themeSection: some View {
        HStack {
            Text(viewModel.model.themeText)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Button(action: {
                viewModel.selectTheme()
            }) {
                Text(viewModel.model.themeSelectionText)
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.model.priceText)
                .font(.system(size: 16, weight: .medium))
            
            HStack {
                Text("LKR")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                
                TextField("", text: $viewModel.formData.price)
                    .keyboardType(.numberPad)
            }
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
    
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Creating Event...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(12)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    viewModel.errorMessage = nil
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.red)
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}
