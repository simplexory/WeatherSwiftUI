//
//  DailyWeather.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation

struct DailyWeather: Codable {
    let cod: Int
    let message: String?
    let city: DailyWeatherCity?
    let list: [DailyWeatherItem]?
    
    var error: Int? {
        get {
            return cod != 200 ? cod : nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let tmpCod = try? values.decode(Int.self, forKey: .cod)
        self.cod = tmpCod ?? 200
        
        message = try? values.decode(String.self, forKey: .message)
        city = try? values.decode(DailyWeatherCity.self, forKey: .city)
        list = try? values.decode([DailyWeatherItem].self, forKey: .list)
    }
}

struct DailyWeatherCity: Codable {
    let name: String
    let country: String
    let sunset: Int
    let sunrise: Int
}

struct DailyWeatherItem: Codable {
    let dt: Date
    let weather: [WeatherCondition]?
    let main: CurrentWeatherTemperature?
    let wind: CurrentWindCondition?
    let visibility: Int?
}
