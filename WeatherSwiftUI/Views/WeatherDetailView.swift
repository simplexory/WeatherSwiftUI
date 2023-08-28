//
//  WeatherDetailView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import SwiftUI

struct WeatherDetailView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var weatherSummaryViewModel: WeatherSummaryView.ViewModel {
        return WeatherSummaryView.ViewModel(
            locationName: viewModel.observedWeather?.city ?? "No Response",
            currentTemp: viewModel.observedWeather?.current?.temperature ?? .C(0),
            condition: viewModel.observedWeather?.current?.condition ?? "No Response",
            highTemp: viewModel.observedWeather?.current?.maxTemperature ?? .C(0),
            lowTemp: viewModel.observedWeather?.current?.minTemperature ?? .C(0)
        )
    }
    
    var hourlyForecastViewModel: HourlyForecastView.ViewModel {
        var weatherSnapshot = [WeatherSnapshot]()
        let summary = "Sunny conditions will continue for the reset of the day. Some text continues..........."
        
        if let forecast = viewModel.observedWeather?.forecast {
            for item in forecast {
                weatherSnapshot.append(WeatherSnapshot(
                    time: item.timestamp,
                    imageURL: item.url,
                    temperature: item.temperature
                ))
            }
        }
        
        return HourlyForecastView.ViewModel(
            currentWeatherSummary: summary,
            hourlySnapshot: weatherSnapshot
        )
    }
    
    var dailyForecastViewModel: DailyForecastView.ViewModel {
        return DailyForecastView.ViewModel(forecastItems: viewModel.observedWeather?.forecast)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            WeatherSummaryView(viewModel: weatherSummaryViewModel)
                .padding(.bottom, 30)
            
            HourlyForecastView(viewModel: hourlyForecastViewModel)
            
            DailyForecastView(viewModel: dailyForecastViewModel)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .refreshable {
            viewModel.handleRefresh()
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HStack {
                Spacer()
        
                WeatherDetailView().environmentObject({ () -> WeatherViewModel in
                    let viewModel = WeatherViewModel(mock: true)
                    viewModel.citiesWeather["Paris"] = Weather(
                        mockCurrentWeather: previewCurrentWeather,
                        mockDailyWeather: previewDailyWeather
                    )
                    viewModel.citiesWeather["London"] = Weather(
                        mockCurrentWeather: previewCurrentWeather,
                        mockDailyWeather: previewDailyWeather
                    )
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
