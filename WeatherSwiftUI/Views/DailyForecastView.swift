//
//  DailyForecastView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import SwiftUI

struct DailyForecastView: View {
    @StateObject var viewModel: DailyForecastView.ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(systemIcon: "list.dash", text: "7-day forecast")
            
            Divider()
            
            ForEach(viewModel.days, id: \.day) { item in
                VStack {
                    DailyForecastRowView(
                        viewModel: DailyForecastRowView.ViewModel(
                            dayTime: item.day,
                            icon: item.icon,
                            minTemp: .C(item.minTemp),
                            maxTemp: .C(item.maxTemp)
                        )
                    )
                }
            }
        }
        .foregroundColor(.white)
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                Spacer()
                DailyForecastView(viewModel: .mockData)
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension DailyForecastView {
    class ViewModel: ObservableObject {
        let days: [ForecastDayDetail]
        
        init(forecastItems: [CompleteWeatherListItem]?) {
            var days = [ForecastDayDetail]()
            
            guard let forecastItems else {
                self.days = days
                return
            }
            
            var observedDay = Date().dayFormatted()
            var index = 0
            
            let firstItem = ForecastDayDetail(
                day: "Today",
                temperatures: [forecastItems.first!.temperature.valueInC],
                icon: forecastItems.first!.icon
            )
            
            days.append(firstItem)
            
            for item in forecastItems {
                if observedDay != item.timestamp.dayFormatted() {
                    observedDay = item.timestamp.dayFormatted()
                    index += 1
                    let detail = ForecastDayDetail(
                        day: observedDay,
                        temperatures: [item.temperature.valueInC],
                        icon: item.icon
                    )
                    days.append(detail)
                } else {
                    days[index].temperatures.append(item.temperature.valueInC)
                }
            }
            
            self.days = days
        }
    }
}

extension DailyForecastView.ViewModel {
    static let weatherModel = Weather(
        mockCurrentWeather: previewCurrentWeather,
        mockDailyWeather: previewDailyWeather
    )
    
    static var mockData: DailyForecastView.ViewModel {
        return DailyForecastView.ViewModel(forecastItems: weatherModel.forecast)
    }
}
