//
//  Weather.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation

struct Weather: Codable {
    var city: String?
    var forecast: [CompleteWeatherListItem]?
    var currentWeather: CompleteCurrentWeatherItem?
    
    var error: Bool = false
    var errorCode: Int?
    
    init(currentWeather: CurrentWeather, dailyWeather: DailyWeather) throws {
        if let currentWeatherError = currentWeather.error {
            self.error = true
            self.errorCode = currentWeatherError
            return
        }else {
            self.currentWeather = try CompleteCurrentWeatherItem(currentWeather: currentWeather)
            self.city = currentWeather.name
        }
        
        if let dailyWeatherError = dailyWeather.error {
            self.error = true
            self.errorCode = dailyWeatherError
            return
        }else {
            self.forecast = []
            if let dailyWeatherList = dailyWeather.list {
                for dw in dailyWeatherList {
                    self.forecast?.append(try CompleteWeatherListItem(dailyWeatherItem: dw))
                }
            }
            
        }
    }
}

struct CompleteCurrentWeatherItem: Codable {
    let timestamp: Date
    let condition: String
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let icon: String
    
    init(currentWeather: CurrentWeather) throws {
        guard let currentWeatherStrings = currentWeather.weather?.first,
              let currentMainStrings = currentWeather.main
        else {
            throw WeatherFetchError.invalidData
        }
        
        self.timestamp = Date()
        self.condition = currentWeatherStrings.description
        self.temperature = currentMainStrings.temp
        self.minTemperature = currentMainStrings.temp_min
        self.maxTemperature = currentMainStrings.temp_max
        self.icon = currentWeatherStrings.icon
    }
}

struct CompleteWeatherListItem: Codable {
    let timestamp: Date
    let condition: String
    let description: String
    let icon: String
    let temperature: Double
    
    init(dailyWeatherItem: DailyWeatherItem) throws {
        self.timestamp = dailyWeatherItem.dt

        guard let dailyWeatherStrings = dailyWeatherItem.weather?.first,
              let dailyWeatherTemperature = dailyWeatherItem.main
        
        else {
            throw WeatherFetchError.invalidData
        }
        
        self.condition = dailyWeatherStrings.main
        self.description = dailyWeatherStrings.description
        self.icon = dailyWeatherStrings.icon
        self.temperature = dailyWeatherTemperature.temp
    }
}

