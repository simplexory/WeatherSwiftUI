//
//  Date+Extension.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 27.08.23.
//

import Foundation

extension Date {
    func hourFormatted() -> String {
        let dateFormatted = DateFormatter()
        dateFormatted.dateFormat = "HH"
        return dateFormatted.string(from: self)
    }
    
    func dayFormatted() -> String {
        let dateFormatted = DateFormatter()
        dateFormatted.dateFormat = "EEEE"
        return dateFormatted.string(from: self)
    }
}



