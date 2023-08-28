//
//  CitiesListView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import SwiftUI

struct CitiesListView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    @State private var searchFieldText: String = ""
    @State private var showingDetail = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        TextField("Search for a city...",
                                  text: $searchFieldText
                        )
                        .scenePadding()
                        .background(.regularMaterial).cornerRadius(10)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            showingDetail.toggle()
                            viewModel.loadData(method: .city(searchFieldText))
                        }.fullScreenCover(isPresented: $showingDetail) {
                            WeatherView(isShowingModal: true)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    VStack {
                        ForEach(0..<11) { _ in
                            CityView()
                                .padding(.bottom, 5)
                        }
                    }
                    
                    
                }
            }
            .navigationTitle(Text("Weather"))
        }
    }
}

struct CitiesListView_Previews: PreviewProvider {
    static var previews: some View {
            CitiesListView().environmentObject({ () -> WeatherViewModel in
                let viewModel = WeatherViewModel(mock: true)
                viewModel.citiesWeather["Paris"] = Weather(
                    mockCurrentWeather: previewCurrentWeather,
                    mockDailyWeather: previewDailyWeather
                )
                viewModel.citiesWeather["London"] = Weather(
                    mockCurrentWeather: previewCurrentWeather,
                    mockDailyWeather: previewDailyWeather
                )
                viewModel.citiesWeather["Vitebsk"] = Weather(
                    mockCurrentWeather: previewCurrentWeather,
                    mockDailyWeather: previewDailyWeather
                )
                viewModel.citiesWeather["Minsk"] = Weather(
                    mockCurrentWeather: previewCurrentWeather,
                    mockDailyWeather: previewDailyWeather
                )
                viewModel.citiesWeather["Moscow"] = Weather(
                    mockCurrentWeather: previewCurrentWeather,
                    mockDailyWeather: previewDailyWeather
                )
                viewModel.observedWeather = Weather(
                    mockCurrentWeather: previewCurrentWeather,
                    mockDailyWeather: previewDailyWeather
                )
                return viewModel
            } () ).preferredColorScheme(.dark)
    }
}
