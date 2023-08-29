//
//  Errors.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 28.08.23.
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

enum LocationError: Error, LocalizedError {
    case locationNotFound
    case locationDenied
    case locationNotDetermined
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .locationNotFound:
            return "City not found"
        case .locationDenied:
            return "Current location data was restricted or denied, please set location permission in settings."
        case .locationNotDetermined:
            return "Finding location. Please wait..."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
