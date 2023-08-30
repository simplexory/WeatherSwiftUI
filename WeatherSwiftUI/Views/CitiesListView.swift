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
        ScrollView {
            VStack(alignment: .leading) {
                Text("Weather")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 8)
                    .padding(.top, 40)
                
                Spacer()
                
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
                        if viewModel.cities.contains(searchFieldText) {
                            viewModel.observedWeather = viewModel.citiesWeather[searchFieldText]
                        } else {
                            viewModel.loadData(method: .city(searchFieldText), makeObserved: true)
                        }
                    }.fullScreenCover(isPresented: $showingDetail, onDismiss: {
                        viewModel.handleRefreshStoredWeather()
                    }) {
                        WeatherView(isShowingModal: true)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                VStack {
                    CityUserView(viewModel: CityUserView.ViewModel(
                        name: viewModel.userWeather?.city ?? "",
                        temperature: viewModel.userWeather?.current?.temperature ?? .C(0),
                        minTemp: viewModel.userWeather?.current?.minTemperature ?? .C(0),
                        maxTemp: viewModel.userWeather?.current?.maxTemperature ?? .C(0),
                        condition: viewModel.userWeather?.current?.condition ?? ""
                    ))
                    .onTapGesture {
                        viewModel.removeError()
                        viewModel.observedWeather = viewModel.userWeather
                        showingDetail.toggle()
                    }
                    .fullScreenCover(isPresented: $showingDetail) {
                        WeatherView(isShowingModal: true)
                            .onDisappear {
                                viewModel.userWeather = viewModel.observedWeather
                                viewModel.handleRefreshStoredWeather()
                            }
                    }
                    
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
                            .onTapGesture {
                                viewModel.removeError()
                                viewModel.observedWeather = viewModel.citiesWeather[cityName]
                                showingDetail.toggle()
                            }
                            .fullScreenCover(isPresented: $showingDetail) {
                                WeatherView(isShowingModal: true)
                                    .onDisappear {
                                        viewModel.handleRefreshStoredWeather()
                                    }
                            }
                        } else {
                            LoadingDataView()
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.handleRefreshStoredWeather()
        }
        .onAppear {
            viewModel.handleRefreshStoredWeather()
        }
    }
}

struct CitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        CitiesListView()
            .environmentObject(WeatherViewModel(mock: true))
            .preferredColorScheme(.dark)
    }
}
