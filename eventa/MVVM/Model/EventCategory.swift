import Foundation
import SwiftUI

struct EventCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var isSelected: Bool = false
}
