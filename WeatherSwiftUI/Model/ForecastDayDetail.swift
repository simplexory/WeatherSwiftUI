//
//  DailyWeatherSnapshot.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import Foundation

struct ForecastDayDetail {
    let day: String
    var temperatures: [Int]
    let icon: String
    
    var minTemp: Int {
        get { temperatures.min() ?? 0 }
    }
    
    var maxTemp: Int {
        get { temperatures.max() ?? 0 }
    }
}
