//
//  Temperature.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import Foundation

enum Temperature: Codable, Equatable {
    
    static let degreeSymbol: String = "°"
    
    case F(_ value: Int)
    case C(_ value: Int)
    
    var valueInF: Int {
        switch self {
        case .F(let value): return value
        case .C(let value): return Int(((Double(value) * 1.8) + 32).rounded())
        }
    }
    
    var valueInC: Int {
        switch self {
        case .F(let value): return Int(((Double(value) - 32.0) * 0.5556).rounded())
        case .C(let value): return value
        }
    }
    
    var celsiusString: String {
        return "\(valueInC)\(Temperature.degreeSymbol)"
    }
    
    var fahrenheitString: String {
        return "\(valueInF)\(Temperature.degreeSymbol)"
    }
}
