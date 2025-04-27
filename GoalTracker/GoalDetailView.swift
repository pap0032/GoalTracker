//
//  GoalDetailView.swift
//  
//
//  Created by Patrick Parks on 4/22/25.
//
import SwiftUI

struct GoalDetailView: View {
    @Binding var goal: Goal
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var progressPercent: Double = 0
    @State private var showCompletionCheckmark = false
    @State private var encouragementPopup: String? = nil
    @State private var checkmarkScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text(goal.title)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text(goal.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text("Target Date: \(goal.targetDate.formatted(date: .long, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                ZStack {
                    if showCompletionCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.green)
                            .frame(width: 150, height: 150)
                            .scaleEffect(checkmarkScale)
                            .transition(.scale)
                            .animation(.easeInOut, value: checkmarkScale)
                    } else {
                        Circle()
                            .stroke(lineWidth: 12)
                            .opacity(0.3)
                            .foregroundColor(.blue)

                        Circle()
                            .trim(from: 0.0, to: CGFloat(progressPercent / 100))
                            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.blue)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.easeInOut, value: progressPercent)

                        Text("\(Int(progressPercent))%")
                            .font(.title2)
                            .bold()
                    }
                }
                .frame(width: 150, height: 150)
                .padding()

                VStack(spacing: 10) {
                    Slider(value: $progressPercent, in: 0...100, step: 1)
                        .padding(.horizontal)
                        .onChange(of: progressPercent) { newValue in
                            let newProgress = Int((newValue / 100.0) * Double(goal.targetProgress))
                            viewModel.updateGoalProgress(goal: goal, newProgress: newProgress)
                            goal.currentProgress = newProgress

                            withAnimation {
                                showCompletionCheckmark = (Int(newValue) == 100)
                            }

                            if Int(newValue) == 100 {
                                bounceCheckmark()
                                checkForEncouragement(for: Int(newValue))
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    goal.isManuallyCompleted = true
                                    dismiss()
                                }
                            } else {
                                checkForEncouragement(for: Int(newValue))
                            }
                        }
                }

                Spacer()
            }

            if let popup = encouragementPopup {
                VStack {
                    Spacer()
                    Text(popup)
                        .font(.headline)
                        .padding()
                        .background(Color.purple.opacity(0.8))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .padding(.bottom, 50)
                        .transition(.opacity)
                        .animation(.easeInOut, value: encouragementPopup)
                }
            }
        }
        .onAppear {
            progressPercent = (Double(goal.currentProgress) / Double(max(goal.targetProgress, 1))) * 100
            showCompletionCheckmark = (Int(progressPercent) == 100)
        }
        .padding()
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func bounceCheckmark() {
        withAnimation(.easeOut(duration: 0.2)) {
            checkmarkScale = 1.2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                checkmarkScale = 1.0
            }
        }
    }

    private func checkForEncouragement(for percent: Int) {
        var message: String? = nil
        switch percent {
        case 100:
            message = "Nailed it!"
        case 75:
            message = "You're so close! Finish strong!"
        case 50:
            message = "Halfway point! Don't stop!"
        case 25:
            message = "Great progress, keep it up!"
        default:
            break
        }

        if let newMessage = message {
            encouragementPopup = newMessage
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    encouragementPopup = nil
                }
            }
        }
    }
}

struct GoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoalDetailView(
                goal: .constant(Goal(title: "Test Goal", description: "Testing description", targetProgress: 100, currentProgress: 0, targetDate: Date())),
                viewModel: GoalViewModel()
            )
        }
    }
}
