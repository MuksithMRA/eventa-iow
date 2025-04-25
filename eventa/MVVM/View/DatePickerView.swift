import SwiftUI

struct DatePickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: NewEventViewModel
    
    @State private var selectedDate: Date
    
    init(viewModel: NewEventViewModel) {
        self.viewModel = viewModel
        _selectedDate = State(initialValue: viewModel.formData.date)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: Date.now...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Text("Selected Date: \(formattedDate)")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    viewModel.setDate(selectedDate)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Confirm Date")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
            )
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
}
