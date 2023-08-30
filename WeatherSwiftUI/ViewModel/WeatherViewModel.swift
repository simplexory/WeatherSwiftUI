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
    @Published var userWeather: Weather?
    @Published var cities = [String]()
    
    private let apiKey = "66252e3de78861371fa91da79b0a1090"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let weatherURL = "/weather"
    private let forecastURL = "/forecast"
    private let storageManager = StorageManager.shared
    
    init() {
        loadSavedCities()
        
        switch locationDataManager.locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            loadUserWeather(makeObserved: true)
        case .restricted, .denied:
            self.error = LocationError.locationDenied
        case .notDetermined:
            self.error = LocationError.locationNotDetermined
        default: break
        }
    }
    
    init(mock: Bool = true) {}
    
    func handleRefresh() {
        guard let city = observedWeather?.city else { return }
        observedWeather = nil
        loadData(method: .city(city), makeObserved: true)
    }
    
    func handleRefreshStoredWeather() {
        loadSavedCities()
    }
    
    func saveObservedCity() {
        guard let city = observedWeather?.city else { return }
        storageManager.saveCity(cityName: city)
        loadData(method: .city(city))
    }
    
    func removeObservedCity() {
        guard let city = observedWeather?.city else { return }
        storageManager.removeCity(cityName: city)
        citiesWeather[city] = nil
        loadCities()
    }
    
    func loadSavedCities() {
        loadCities()
        
        for city in cities {
            loadData(method: .city(city))
        }
    }
    
    private func loadCities() {
        let loadedCities = storageManager.loadCities()
        cities = loadedCities
    }
    
    func removeError() {
        self.error = nil
    }
    
    func removeAllSavedCities() {
        storageManager.removeAll()
    }
    
    func cityIsSaved(cityName: String) -> Bool {
        return cities.contains(cityName)
    }
}

extension WeatherViewModel {
    func loadUserWeather(makeObserved: Bool = false) {
        Task(priority: .medium) {
            do {
                guard let location = locationDataManager.locationManager.location else { return }
                
                let weather = try await requestWeather(method:.coordinate(
                    location.coordinate.latitude,
                    location.coordinate.longitude)
                )
                self.userWeather = weather
                
                if makeObserved {
                    self.observedWeather = weather
                }
            } catch {
                self.error = error
            }
        }
    }
    
    func loadData(method: WeatherReqestMethod, makeObserved: Bool = false) {
        if makeObserved {
            observedWeather = nil
        }
        
        Task(priority: .medium) {
            do {
                switch method {
                case .city(let city):
                    let weather = try await requestWeather(method: method)
                    self.citiesWeather[city] = weather
                    
                    if makeObserved {
                        self.observedWeather = weather
                    }
                case .coordinate:
                    let weather = try await requestWeather(method: method)
                    self.citiesWeather[weather?.city ?? "User location"] = weather
                    
                    if makeObserved {
                        self.observedWeather = weather
                    }
                }
            } catch {
                self.error = error
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
                throw WeatherFetchError.invalidData
            }
            
            let weather = try Weather(currentWeather: currentWeather, dailyWeather: dailyForecast)
            return weather
        }
    }
}
