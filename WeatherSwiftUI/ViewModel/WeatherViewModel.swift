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
    @Published var locationDataManager = LocationDataManager()
    @Published var citiesWeather = [String: Weather]()
    @Published var observedWeather: Weather?
    @Published var error: Error?
    
    var cities = [String]()
    private let apiKey = "66252e3de78861371fa91da79b0a1090"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let weatherURL = "/weather"
    private let forecastURL = "/forecast"
    
    init() {
        switch locationDataManager.locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            guard let location = locationDataManager.locationManager.location else { return }
            
            loadData(method: .coordinate(
                location.coordinate.latitude,
                location.coordinate.longitude
            ))
        case .restricted, .denied:
            self.error = LocationError.locationDenied
        case .notDetermined:
            self.error = LocationError.locationNotDetermined
        default: break
        }
    }
    
    init(mock: Bool = true) {}
}

extension WeatherViewModel {
    func loadData(method: WeatherReqestMethod) {
        Task(priority: .medium) {
            switch method {
            case .city(let city):
                guard let _ = citiesWeather[city] else { return }
                do {
                    let weather = try await requestWeather(method: method)
                    self.observedWeather = weather
                    self.citiesWeather[city] = weather
                } catch {
                    self.error = error // ?????????
                }
            case .coordinate:
                do {
                    self.observedWeather = try await requestWeather(method: method)
                } catch {
                    self.error = error //  ?????? need test
                }
            }
        }
    }
}

extension WeatherViewModel {
    func getCurrentWeather(method: WeatherReqestMethod) async throws -> CurrentWeather {
        var urlString: String
        
        switch method {
        case .city(let city):
            urlString = "\(baseURL)\(weatherURL)?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let lat, let lon):
            urlString = "\(baseURL)\(weatherURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        }
        
        guard let url = URL(string: urlString) else { throw WeatherFetchError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw WeatherFetchError.serverError }
        guard let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: data) else { throw WeatherFetchError.invalidData }
        return currentWeather
    }
    
    func getDailyForecast(method: WeatherReqestMethod) async throws -> DailyWeather {
        var urlString: String
        
        switch method {
        case .city(let city):
            urlString = "\(baseURL)\(forecastURL)?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let lat, let lon):
            urlString = "\(baseURL)\(forecastURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        }
        
        guard let url = URL(string: urlString) else { throw WeatherFetchError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw WeatherFetchError.serverError }
        guard let dailyWeather = try? JSONDecoder().decode(DailyWeather.self, from: data) else { throw WeatherFetchError.invalidData }
        return dailyWeather
    }
    
    func requestWeather(method: WeatherReqestMethod) async throws -> Weather? {
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
            return weather
        }
    }
}
