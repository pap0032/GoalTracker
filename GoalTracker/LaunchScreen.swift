//
//  LaunchScreen.swift
//
//
//  Created by Patrick Parks on 4/22/25.
//
import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "target")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                Text("Goal Tracker")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
