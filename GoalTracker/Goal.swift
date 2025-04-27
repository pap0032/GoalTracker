//
//  Goal.swift
//
//
//  Created by Patrick Parks on 4/22/25.
//
import Foundation

struct Goal: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var targetProgress: Int
    var currentProgress: Int
    var targetDate: Date
    var isManuallyCompleted: Bool = false

    var isCompleted: Bool {
        currentProgress >= targetProgress
    }
}

