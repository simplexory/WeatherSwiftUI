//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import SwiftUI
import CoreLocation

struct WeatherSummaryView: View {
    @StateObject var viewModel: WeatherSummaryView.ViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.locationName)
                .font(.largeTitle)
            Text(viewModel.currentTemp.celsiusString)
                .font(Font.system(size: 100))
                .fontWeight(.ultraLight)
            Text(viewModel.condition)
                .font(.title3)
                .padding(.bottom, -5)
            Text("H:\(viewModel.lowTemp.celsiusString) L:\(viewModel.highTemp.celsiusString)")
                .font(.title3)
        }
    }
    
}


struct WeatherSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            HStack {
                Spacer()
                WeatherSummaryView(viewModel: .sunnyMockData)
                Spacer()
            }
            .padding(.top, 10)
        }
        .preferredColorScheme(.dark)
        
        ScrollView {
            HStack {
                Spacer()
                WeatherSummaryView(viewModel: .rainingMockData)
                Spacer()
            }
            .padding(.top, 10)
        }
        .preferredColorScheme(.dark)
    }
}

extension WeatherSummaryView {
    class ViewModel: ObservableObject {
        let locationName: String
        let currentTemp: Temperature
        let condition: String
        let highTemp: Temperature
        let lowTemp: Temperature
        
        init(
            locationName: String,
            currentTemp: Temperature,
            condition: String,
            highTemp: Temperature,
            lowTemp: Temperature) {
                
            self.locationName = locationName
            self.currentTemp = currentTemp
            self.condition = condition
            self.highTemp = highTemp
            self.lowTemp = lowTemp
        }
    }
}

extension WeatherSummaryView.ViewModel {
    static var sunnyMockData: WeatherSummaryView.ViewModel {
        return WeatherSummaryView.ViewModel(
            locationName: "Minsk",
            currentTemp: .C(21),
            condition: "Hell",
            highTemp: .C(28),
            lowTemp: .C(18)
        )
    }
    
    static var rainingMockData: WeatherSummaryView.ViewModel {
        return WeatherSummaryView.ViewModel(
            locationName: "Vitebsk",
            currentTemp: .C(14),
            condition: "Raining hell",
            highTemp: .C(10),
            lowTemp: .C(17)
        )
    }
}
