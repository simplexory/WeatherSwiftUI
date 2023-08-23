//
//  WeatherViewModel.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation
import CoreLocation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var citiesWeather = [String: Weather]()
    @Published var userWeather: Weather?
    
    var cities = [String]()
    private let apiKey = "66252e3de78861371fa91da79b0a1090"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let weatherURL = "/weather"
    private let forecastURL = "/forecast"
    
    init() {
        let coordinates = CLLocationCoordinate2D(latitude: 55.1927, longitude: 30.2064)
        loadData(method: .coordinate(coordinates.latitude, coordinates.longitude))
    }
}

extension WeatherViewModel {
    func loadData(method: WeatherReqestMethod) {
        Task(priority: .medium) {
            switch method {
            case .city(let city):
                guard let _ = citiesWeather[city] else { return }
                do {
                    let weather = try await requestWeather(method: method)
                    self.citiesWeather[city] = weather
                } catch {
                    throw WeatherFetchError.serverError
                }
            case .coordinate:
                do {
                    self.userWeather = try await requestWeather(method: method)
                } catch {
                    throw WeatherFetchError.serverError
                }
            }
        }
    }
}

extension WeatherViewModel {
    func getCurrentWeather(method: WeatherReqestMethod) async throws -> CurrentWeather {
        var url: URL
        
        switch method {
        case .city(let city):
            url = URL(string: "\(baseURL)\(weatherURL)?q=\(city)&appid=\(apiKey)&units=metric")!
        case .coordinate(let lat, let lon):
            url = URL(string: "\(baseURL)\(weatherURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw WeatherFetchError.serverError }
        guard let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: data) else { throw WeatherFetchError.invalidData }
        return currentWeather
    }
    
    func getDailyForecast(method: WeatherReqestMethod) async throws -> DailyWeather {
        var url: URL
        
        switch method {
        case .city(let city):
            url = URL(string: "\(baseURL)\(forecastURL)?q=\(city)&appid=\(apiKey)&units=metric")!
        case .coordinate(let lat, let lon):
            url = URL(string: "\(baseURL)\(forecastURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")!
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw WeatherFetchError.serverError }
        guard let dailyWeather = try? JSONDecoder().decode(DailyWeather.self, from: data) else { throw WeatherFetchError.invalidData }
        return dailyWeather
    }
    
    func requestWeather(method: WeatherReqestMethod) async throws -> Weather {
        return try await withThrowingTaskGroup(of: WeatherFetchType.self) { group -> Weather in
            
            group.addTask {
                let currentWeather = try await self.getCurrentWeather(method: method)
                return .current(currentWeather)
            }
            
            group.addTask {
                let dailyForecast = try await self.getDailyForecast(method: method)
                return .daily(dailyForecast)
            }
        
            var dailyForecast: DailyWeather?
            var currentWeather: CurrentWeather?
            
            for try await weatherData in group {
                switch weatherData {
                case .current(let currentWeatherData):
                    currentWeather = currentWeatherData
                    break
                case .daily(let dailyForecastData):
                    dailyForecast = dailyForecastData
                    break
                }
            }
            
            guard let dailyForecast = dailyForecast,
                  let currentWeather = currentWeather else {
                throw WeatherFetchError.serverError
            }
            
            let weather = try Weather(currentWeather: currentWeather, dailyWeather: dailyForecast)
            print(weather)
            return weather
        }
    }
}
