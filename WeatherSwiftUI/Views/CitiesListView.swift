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
                            viewModel.loadData(method: .city(searchFieldText), makeObserved: true)
                        }.fullScreenCover(isPresented: $showingDetail) {
                            WeatherView(isShowingModal: true)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    VStack {
                        ForEach(viewModel.cities, id: \.self) { cityName in
                            if viewModel.citiesWeather[cityName] != nil {
                                CityView(viewModel: CityView.ViewModel(
                                    name: viewModel.citiesWeather[cityName]?.city ?? "Loading...",
                                    time: Date().detailHourFromGMT(timezone: viewModel.citiesWeather[cityName]?.timezone ?? 0),
                                    temperature: viewModel.citiesWeather[cityName]?.current?.temperature ?? .C(0),
                                    minTemp: viewModel.citiesWeather[cityName]?.current?.minTemperature ?? .C(0),
                                    maxTemp: viewModel.citiesWeather[cityName]?.current?.maxTemperature ?? .C(0),
                                    condition: viewModel.citiesWeather[cityName]?.current?.condition ?? ""
                                ))
                            } else {
                                LoadingDataView()
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Weather"))
            .refreshable {
                viewModel.handleRefreshStoredWeather()
            }
        }
    }
}

struct CitiesListView_Previews: PreviewProvider {
    static var previews: some View {
            CitiesListView().environmentObject({ () -> WeatherViewModel in
                let cities = ["Paris", "London", "Vitebsk", "Minsk", "Moscow"]
                
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
                
                viewModel.cities = cities
                return viewModel
            } () ).preferredColorScheme(.dark)
    }
}
