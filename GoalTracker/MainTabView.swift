//
//  MainTabView.swift
//
//
//  Created by Patrick Parks on 4/22/25.
//
import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = GoalViewModel()

    var body: some View {
        TabView {
            GoalListView(viewModel: viewModel)
                .tabItem {
                    Label("Active Goals", systemImage: "list.bullet")
                }
            
            CompletedGoalsView(viewModel: viewModel)
                .tabItem {
                    Label("Completed", systemImage: "checkmark.circle")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

