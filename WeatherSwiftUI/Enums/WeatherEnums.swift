//
//  WeatherEnums.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation

enum WeatherFetchType {
    case current(CurrentWeather)
    case daily(DailyWeather)
}

enum WeatherType {
    case currentWeather
    case dailyWeather
}

enum WeatherReqestMethod {
    case city(String)
    case coordinate(Double, Double)
}
