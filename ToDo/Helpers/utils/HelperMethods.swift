import Foundation
import SwiftUI

class HelperMethods {
    public static func priorityColor(_ priority: TasksPriority) -> Color {
        switch priority {
            case .low:
                return .green
            case .medium:
                return .orange
            case .high:
                return .red
        }
    }

    public static func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
