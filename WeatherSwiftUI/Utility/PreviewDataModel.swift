//
//  DataModel.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import Foundation

var previewCurrentWeather: CurrentWeather = load("currentWeatherJSON.json")
var previewDailyWeather: DailyWeather = load("forecastWeatherJSON.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find file with \(filename) in main bundle")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse data from \(filename) as \(T.self):\n\(error)")
    }
}
