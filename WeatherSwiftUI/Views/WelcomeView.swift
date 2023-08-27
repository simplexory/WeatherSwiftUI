//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        if viewModel.observedWeather != nil {
            WeatherDetailView()
        } else {
            LoadingDataView()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HStack {
                Spacer()
                
                WelcomeView().environmentObject({ () -> WeatherViewModel in
                    let viewModel = WeatherViewModel(mock: true)
                    viewModel.locationDataManager.authorizationStatus = .authorizedWhenInUse
                    viewModel.observedWeather = Weather(
                        mockCurrentWeather: previewCurrentWeather,
                        mockDailyWeather: previewDailyWeather
                    )
                    return viewModel
                }() )
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .preferredColorScheme(.dark)
    }
}
