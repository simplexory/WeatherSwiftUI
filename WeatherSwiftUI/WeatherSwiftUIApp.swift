//
//  WeatherSwiftUIApp.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import SwiftUI

@main
struct WeatherSwiftUIApp: App {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
