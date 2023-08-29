//
//  StorageManager.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 28.08.23.
//

import Foundation

private extension String {
    static let city = "cityName"
}

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    func saveCity(cityName: String) {
        var cities = Set(loadCities())
        cities.insert(cityName)
        saveCities(cities: [String](cities))
    }
    
    func loadCities() -> [String] {
        guard let cities = UserDefaults.standard.object(forKey: .city) as? [String] else { return [] }
        return cities
    }
    
    func removeCity(cityName: String) {
        var cities = loadCities()
        for (index, element) in cities.enumerated() {
            if element == cityName {
                cities.remove(at: index)
            }
        }
        saveCities(cities: cities)
    }
    
    private func saveCities(cities: [String]) {
        UserDefaults.standard.set(cities, forKey: .city)
    }
    
    func removeAll() {
        UserDefaults.standard.removeObject(forKey: .city)
    }
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T?  {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        
        return nil
    }
}
