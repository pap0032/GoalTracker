//
//  AddGoalView.swift
//  
//
//  Created by Patrick Parks on 4/22/25.
//
import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GoalViewModel

    @State private var title = ""
    @State private var description = ""
    @State private var targetDate = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Goal Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
            }
            .navigationTitle("New Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addGoal(title: title, description: description, targetProgress: 100, targetDate: targetDate)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView(viewModel: GoalViewModel())
    }
}
