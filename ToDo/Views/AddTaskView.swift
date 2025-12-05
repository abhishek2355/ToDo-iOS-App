import SwiftUI
import SwiftData

struct AddTaskView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @State private var priority: TasksPriority = .medium


    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Info")) {
                    TextField("Task title", text: $title)
                    TextField("Notes (optional)", text: $notes)
                }

                Section(header: Text("Due Date")) {
                    Toggle("Set a due date", isOn: $hasDueDate)

                    if hasDueDate {
                        DatePicker("Select date", selection: $dueDate, displayedComponents: .date)
                    }
                }

                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(TasksPriority.allCases, id: \.self) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newTask = TaskModel(
                            title: title,
                            notes: notes,
                            isCompleted: false,
                            createdAt: .now,
                            dueDate: hasDueDate ? dueDate : nil,
                            priority: priority
                        )
                        context.insert(newTask)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddTaskView()
}
