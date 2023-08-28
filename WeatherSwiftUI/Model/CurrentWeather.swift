//
//  CurrentWeather.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation

struct CurrentWeather: Codable {
    let weather: [WeatherCondition]?
    let main: CurrentWeatherTemperature?
    let wind: CurrentWindCondition?
    let sys: CurrentSunCondition?
    let name: String?
    let cod: Int
    let message: String?
    let visibility: Int?
    let timezone: Int
    
    var error: Int? {
        get {
            return cod != 200 ? cod : nil
        }
    }
}

struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct CurrentWeatherTemperature: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct CurrentWindCondition: Codable {
    let speed: Double
    let deg: Int
}

struct CurrentCloudCondition: Codable {
    let all: Int
}

struct CurrentSunCondition: Codable {
    let sunrise: Int
    let sunset: Int
}
