//
//  ForecastWeatherViewModel.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/02.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation
import UIKit

struct  ForecastWeatherViewModel {
    var weekday: String?
    var temperature: String?
    var weatherCondition: String?
    
    init?(model: ForecastWeather) {
        self.weekday = ForecastWeatherViewModel.getDayOfWeek(from: model.date)
        self.weatherCondition = model.weatherCondition
        self.temperature = TodayWeatherViewModel.formatValue(value: model.temperature, endStringWith: "°")
    }
    
    static func getDayOfWeek(from fromDate: Double) -> String {
        let date = Date(timeIntervalSince1970: fromDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        
        return dayOfWeekString
    }
}
