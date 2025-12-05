import SwiftUI
import SwiftData

struct TaskDetailsView: View {
    @Bindable var task: TaskModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(task.title)
                        .font(.system(size: 26, weight: .bold))

                    Spacer()

                    Text(task.priority.rawValue.capitalized)
                        .font(.footnote)
                        .padding(6)
                        .background(HelperMethods.priorityColor(task.priority).opacity(0.2))
                        .cornerRadius(6)
                }

                Text(task.notes)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.secondary)

                HStack {
                    Text("Status: ")
                        .font(.headline)

                    Text(task.isCompleted ? "Completed" : "Pending")
                        .foregroundStyle(task.isCompleted ? .green : .orange)
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("Created")
                            .font(.headline)

                        Text(HelperMethods.formattedDate(task.createdAt))
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                    }

                    Spacer()

                    if let due = task.dueDate {
                        if !task.isCompleted {
                            VStack(alignment: .leading) {
                                Text("Due Date")
                                    .font(.headline)

                                Text(HelperMethods.formattedDate(due))
                                    .font(.subheadline)
                                    .foregroundStyle(Color.orange)
                            }
                        }
                    }
                }

                VStack(spacing: 12) {
                    NavigationLink {
                        EditTaskView(task: task)
                    } label: {
                        buttonStyle("Edit Task", color: .blue)
                    }

                    Button  (role: .destructive) {
                        deleteTask(task: task)
                    } label: {
                        buttonStyle("Delete Task", color: .red)
                    }

                    if !task.isCompleted {
                        Button {
                            markAsComplete(task: task)
                        } label: {
                            buttonStyle("Mark Completed", color: .green)
                        }
                    }
                }
                .padding(.top, 20)
            }
            .padding()

        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension TaskDetailsView {
    private func deleteTask(task: TaskModel) {
        context.delete(task)
        try? context.save()
        dismiss()
    }

    private func markAsComplete(task: TaskModel) {
        task.isCompleted.toggle()
    }

    private func buttonStyle(_ title: String, color: Color) -> some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}

#Preview {
    TaskDetailsView(task: TaskModel(title: ""))
}
