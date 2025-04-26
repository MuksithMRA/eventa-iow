import SwiftUI
import Combine
import UserNotifications

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = NotificationSettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Promotional Notifications")) {
                    Toggle("Enable Promotional Notifications", isOn: $viewModel.enablePromotionalNotifications)
                        .onChange(of: viewModel.enablePromotionalNotifications) { newValue in
                            if newValue {
                                viewModel.requestNotificationPermission()
                            }
                        }
                    
                    if viewModel.enablePromotionalNotifications {
                        Toggle("Daily Event Updates", isOn: $viewModel.enableDailyNotifications)
                        Toggle("Weekly Featured Events", isOn: $viewModel.enableWeeklyNotifications)
                        Toggle("New Event Announcements", isOn: $viewModel.enableNewEventNotifications)
                    }
                }
                
                Section(header: Text("Notification Frequency")) {
                    Picker("Maximum Notifications", selection: $viewModel.maxNotificationsPerWeek) {
                        Text("1 per week").tag(1)
                        Text("3 per week").tag(3)
                        Text("5 per week").tag(5)
                        Text("No limit").tag(100)
                    }
                    .disabled(!viewModel.enablePromotionalNotifications)
                }
                
                Section {
                    Button(action: {
                        viewModel.saveSettings()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Settings")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        viewModel.cancelAllNotifications()
                    }) {
                        Text("Cancel All Notifications")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        viewModel.testNotification()
                    }) {
                        Text("Test Notification")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Notification Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                viewModel.loadSettings()
            }
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
