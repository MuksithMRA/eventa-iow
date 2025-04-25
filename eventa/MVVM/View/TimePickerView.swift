import SwiftUI

struct TimePickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: NewEventViewModel
    
    @State private var selectedTime: Date
    private let isStartTime: Bool
    
    init(viewModel: NewEventViewModel, isStartTime: Bool) {
        self.viewModel = viewModel
        self.isStartTime = isStartTime
        
        if isStartTime {
            _selectedTime = State(initialValue: viewModel.formData.startTime)
        } else {
            _selectedTime = State(initialValue: viewModel.formData.endTime)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker(
                    "Select Time",
                    selection: $selectedTime,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                
                Text("Selected Time: \(formattedTime)")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    if isStartTime {
                        viewModel.setStartTime(selectedTime)
                    } else {
                        viewModel.setEndTime(selectedTime)
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Confirm Time")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle(isStartTime ? "Select Start Time" : "Select End Time")
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
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedTime)
    }
}
