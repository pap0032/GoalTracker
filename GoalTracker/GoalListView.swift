//
//  GoalListView.swift
//  
//
//  Created by Patrick Parks on 4/22/25.
//
import SwiftUI

struct GoalListView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var showingAddGoal = false
    @State private var selectedSortOption: SortOption = .dueDate
    @State private var pulse = false

    var sortedActiveGoals: [Goal] {
        switch selectedSortOption {
        case .dueDate:
            return viewModel.activeGoals.sorted { $0.targetDate < $1.targetDate }
        case .percentComplete:
            return viewModel.activeGoals.sorted {
                Double($0.currentProgress) / Double(max($0.targetProgress, 1)) >
                Double($1.currentProgress) / Double(max($1.targetProgress, 1))
            }
        case .title:
            return viewModel.activeGoals.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case dueDate = "Due Date"
        case percentComplete = "Percent Complete"
        case title = "Title (A-Z)"

        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationView {
            Group {
                if sortedActiveGoals.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "target")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No Active Goals")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray.opacity(0.8))
                        
                        Text("Tap '+' to add your first goal!")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        Section {
                            Picker("Sort by", selection: $selectedSortOption) {
                                ForEach(SortOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.vertical, 8)
                        }

                        ForEach(sortedActiveGoals) { goal in
                            NavigationLink(destination: GoalDetailView(goal: binding(for: goal), viewModel: viewModel)) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .stroke(lineWidth: 8)
                                            .opacity(0.3)
                                            .foregroundColor(.blue)
                                        
                                        Circle()
                                            .trim(from: 0.0, to: CGFloat(Double(goal.currentProgress) / Double(max(goal.targetProgress, 1))))
                                            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                                            .foregroundColor(.blue)
                                            .rotationEffect(Angle(degrees: -90))
                                            .animation(.easeOut, value: goal.currentProgress)
                                        
                                        Text("\(Int(Double(goal.currentProgress) / Double(max(goal.targetProgress, 1)) * 100))%")
                                            .font(.caption)
                                            .bold()
                                    }
                                    .frame(width: 50, height: 50)

                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text(goal.title)
                                                .font(.headline)
                                            
                                            if goal.targetDate < Date.now {
                                                Text("Overdue")
                                                    .font(.caption2)
                                                    .padding(4)
                                                    .background(Color.red.opacity(0.2))
                                                    .foregroundColor(.red)
                                                    .cornerRadius(5)
                                            }
                                        }
                                        
                                        Text("Target Date: \(goal.targetDate.formatted(date: .long, time: .omitted))")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .scaleEffect(goal.targetDate < Date.now ? (pulse ? 1.05 : 1.0) : 1.0)
                                .animation(goal.targetDate < Date.now ? Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default, value: pulse)
                                .onAppear {
                                    pulse = true
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deleteGoal)
                    }
                }
            }
            .navigationTitle("My Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(viewModel: viewModel)
            }
        }
    }

    private func binding(for goal: Goal) -> Binding<Goal> {
        guard let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) else {
            fatalError("Goal not found in ViewModel")
        }
        return $viewModel.goals[index]
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoalListView(viewModel: GoalViewModel())
        }
    }
}


