//
//  TodayWeatherViewModel.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation

struct TodayWeatherViewModel {
    var temperature: String?
    var weatherCondition: String?
    var maxTemperature: String?
    var minTemperature: String?
    
    init(model: TodayWeather) {
        self.temperature        = TodayWeatherViewModel.formatValue(value: model.temperature, endStringWith: "°")
        self.maxTemperature     = TodayWeatherViewModel.formatValue(value: model.maxTemperature, endStringWith: "°")
        self.minTemperature     = TodayWeatherViewModel.formatValue(value: model.minTemperature, endStringWith: "°")
    }
    
    static func formatValue(value: Double, endStringWith: String = "", castToInt: Bool = true) -> String {
        var returnValue: String
        var defaultString = "-"
        
        if value == Double.infinity {
            returnValue = defaultString
        }
        else if castToInt {
            returnValue = "\(Int(value))"
        }
        else {
            returnValue = "\(value)"
        }
        
        return returnValue.appending(endStringWith)
    }
}
