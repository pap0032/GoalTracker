//
//  GoalViewModel.swift
//  
//
//  Created by Patrick Parks on 4/22/25.
//
import Foundation

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []

    var activeGoals: [Goal] {
        goals.filter { !$0.isManuallyCompleted }
    }

    var completedGoals: [Goal] {
        goals.filter { $0.isManuallyCompleted }
    }

    func addGoal(title: String, description: String, targetProgress: Int, targetDate: Date) {
        let newGoal = Goal(title: title, description: description, targetProgress: targetProgress, currentProgress: 0, targetDate: targetDate)
        goals.append(newGoal)
    }

    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }

    func updateGoalProgress(goal: Goal, newProgress: Int) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].currentProgress = newProgress
        }
    }
}
