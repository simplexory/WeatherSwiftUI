//
//  Weather.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation

struct Weather: Codable {
    var city: String?
    var timezone: Int?
    var forecast: [CompleteWeatherListItem]?
    var current: CompleteCurrentWeatherItem?
    
    var error: Bool = false
    var errorCode: Int?
    
    init(currentWeather: CurrentWeather, dailyWeather: DailyWeather) throws {
        if let currentWeatherError = currentWeather.error {
            self.error = true
            self.errorCode = currentWeatherError
            return
        }else {
            self.current = try CompleteCurrentWeatherItem(currentWeather: currentWeather)
            self.city = currentWeather.name
            self.timezone = currentWeather.timezone
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
    
    init(mockCurrentWeather: CurrentWeather, mockDailyWeather: DailyWeather) {
        self.current = CompleteCurrentWeatherItem(mockCurrentWeather: mockCurrentWeather)
        self.city = mockCurrentWeather.name
        self.forecast = []
        for dw in mockDailyWeather.list! {
            self.forecast?.append(CompleteWeatherListItem(mockDailyWeatherItem: dw))
        }
    }
}

struct CompleteCurrentWeatherItem: Codable {
    let timestamp: Date
    let condition: String
    let temperature: Temperature
    let minTemperature: Temperature
    let maxTemperature: Temperature
    let icon: String
    
    var url: URL { URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")! }
    
    init(currentWeather: CurrentWeather) throws {
        guard let currentWeatherStrings = currentWeather.weather?.first,
              let currentMainStrings = currentWeather.main
        else {
            throw WeatherFetchError.invalidData
        }
        
        self.timestamp = Date()
        self.condition = currentWeatherStrings.description
        self.temperature = Temperature.C(Int(currentMainStrings.temp))
        self.minTemperature = Temperature.C(Int(currentMainStrings.temp_min))
        self.maxTemperature = Temperature.C(Int(currentMainStrings.temp_max))
        self.icon = currentWeatherStrings.icon
    }
    
    init(mockCurrentWeather: CurrentWeather) {
        let currentWeatherStrings = mockCurrentWeather.weather!.first!
        let currentMainStrings = mockCurrentWeather.main!
        
        self.timestamp = Date()
        self.condition = currentWeatherStrings.description
        self.temperature = Temperature.C(Int(currentMainStrings.temp))
        self.minTemperature = Temperature.C(Int(currentMainStrings.temp_min))
        self.maxTemperature = Temperature.C(Int(currentMainStrings.temp_max))
        self.icon = currentWeatherStrings.icon
    }
}

struct CompleteWeatherListItem: Codable {
    let timestamp: Date
    let condition: String
    let description: String
    let icon: String
    let temperature: Temperature
    
    var url: URL { URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")! }
    
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
        self.temperature = Temperature.C(Int(dailyWeatherTemperature.temp))
    }
    
    init(mockDailyWeatherItem: DailyWeatherItem) {
        self.timestamp = mockDailyWeatherItem.dt

        let dailyWeatherStrings = mockDailyWeatherItem.weather!.first!
        let dailyWeatherTemperature = mockDailyWeatherItem.main!
        
        self.condition = dailyWeatherStrings.main
        self.description = dailyWeatherStrings.description
        self.icon = dailyWeatherStrings.icon
        self.temperature = Temperature.C(Int(dailyWeatherTemperature.temp))
    }
}

