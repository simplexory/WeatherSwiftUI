//
//  RoundExtension.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 26.08.23.
//

import Foundation

extension Float {
    func roundFloat() -> String {
        return String(format: "%.0f", self)
    }
}

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
