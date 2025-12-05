import SwiftUI

struct EditTaskView: View {
    @Bindable var task: TaskModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var showDatePicker: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("\(task.title)", text: $task.title)
                        .font(.headline)
                }

                Section("Notes") {
                    TextField("\(task.notes)", text: $task.notes)
                        .font(.body)
                }

                Section("Priority") {
                    Picker("Priority", selection: $task.priority) {
                        ForEach(TasksPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Due Date") {
                    Toggle("Set due date", isOn: $showDatePicker)

                    if showDatePicker {
                        DatePicker("Due",
                                   selection: Binding(
                                    get: { task.dueDate ?? .now },
                                    set: { task.dueDate = $0 }
                                   ),
                                   displayedComponents: .date
                        )
                    }
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EditTaskView(task: TaskModel(title: ""))
}
