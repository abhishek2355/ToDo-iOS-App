import SwiftUI
import SwiftData

struct HomeView: View {

    // MARK: - Properties
    @Environment(\.modelContext) private var context
    @Query(sort: \TaskModel.createdAt, order: .reverse)
    private var tasks: [TaskModel]
    @State private var showingBottomSheet = false

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                // View for empty tasks
                if tasks.isEmpty {
                    Text("NO TASK YET. ADD ONE!")
                        .foregroundStyle(Color.gray)
                        .padding()
                } else {
                    List {
                        ForEach(tasks) { task in
                            NavigationLink {
                                TaskDetailsView(task: task)
                            } label: {
                                HStack {
                                    Button{
                                        task.isCompleted.toggle()
                                        try? context.save()
                                    } label: {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(task.isCompleted ? .green : .gray)
                                    }
                                    .buttonStyle(.plain)

                                    VStack(alignment: .leading) {
                                        Text(task.title)
                                            .lineLimit(1)
                                            .font(.headline)
                                            .strikethrough(task.isCompleted)

                                        if let due = task.dueDate {
                                            Text("Due: \(due.formatted(date: .abbreviated, time: .omitted))")
                                                .font(.caption)
                                                .foregroundStyle(Color.secondary)
                                        }
                                    }

                                    Spacer()

                                    Text(task.priority.rawValue.capitalized)
                                        .font(.footnote)
                                        .padding(6)
                                        .background(HelperMethods.priorityColor(task.priority).opacity(0.2))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                Button {
                    showingBottomSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.gray)
                }
            }
            .sheet(isPresented: $showingBottomSheet) {
                AddTaskView()
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            context.delete(tasks[index])
        }
        try? context.save()
    }
}

#Preview {
    HomeView()
}
