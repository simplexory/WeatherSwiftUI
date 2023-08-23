//
//  WeatherEnums.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation

enum WeatherFetchError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL was invalid, please try again later."
        case .serverError:
            return "There was an error with the server. Please try again later."
        case .invalidData:
            return "The weather data is invalid. Please try again later."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

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
