//
//  CompletedGoalsView.swift
//  
//
//  Created by Patrick Parks on 4/22/25.
//
import SwiftUI

struct CompletedGoalsView: View {
    @ObservedObject var viewModel: GoalViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.completedGoals) { goal in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(goal.title)
                            .font(.headline)
                        
                        Text(goal.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Completed Target: \(goal.targetDate.formatted(date: .long, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Completed Goals")
        }
    }
}

struct CompletedGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedGoalsView(viewModel: GoalViewModel())
    }
}
