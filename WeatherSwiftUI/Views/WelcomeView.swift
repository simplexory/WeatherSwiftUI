//
//  WelcomeView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 29.08.23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            switch viewModel.locationDataManager.locationManager.authorizationStatus {
            case .authorizedWhenInUse:
                WeatherView()
            case .restricted, .denied:
                Text("Current location data was restricted or denied.")
            case .notDetermined:
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(WeatherViewModel())
            .preferredColorScheme(.dark)
    }
}
