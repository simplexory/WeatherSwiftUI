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
        dateFormatted.dateFormat = "E"
        return dateFormatted.string(from: self)
    }
    
    func detailHourFromGMT(timezone: Int = 0) -> String {
        let dateFormatted = DateFormatter()
        dateFormatted.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatted.dateFormat = "HH:mm"
        return dateFormatted.string(from: self)
    }
}



