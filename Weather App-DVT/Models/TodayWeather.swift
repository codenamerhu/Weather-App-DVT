//
//  TodayWeather.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation

struct TodayWeather {
    var temperature: Double         = Double.infinity
    var weatherCondition: String    = ""
    var maxTemperature: Double      = Double.infinity
    var minTemperature: Double      = Double.infinity
    
    var date: Double = Double.infinity
}

extension TodayWeather {
    
    struct Key {
        
        static let date = "dt"
        
        // MARK:- Main
        static let mainKey          = "main"
        static let temperature      = "temp"
        static let maxTemparature   = "temp_max"
        static let minTemperature   = "temp_min"
        
        // MARK:- Rain
        static let rainKey          = "rain"
        static let precitipation    = "3h"
        
        // MARK:- Weather[0]
        static let weather          = "weather"
        static let icon             = "icon"
        static let weatherCondition = "main"
    }
    
    init?(dataInJSON: [String:AnyObject]) {
        
        if let main = dataInJSON[Key.mainKey] as? Dictionary<String, AnyObject> {
            if let temparatureValue = main[Key.temperature] as? Double {
                self.temperature = temparatureValue
            }
            
            if let maximumTemperature = main[Key.maxTemparature] as? Double {
                self.maxTemperature = maximumTemperature
            }
            
            if let minimunTemperature = main[Key.minTemperature] as? Double {
                self.minTemperature = minimunTemperature
            }
            
        }
        
        if let weather = dataInJSON[Key.weather]![0] as? Dictionary<String, AnyObject> {
            
            if let condition = weather[Key.weatherCondition] as? String {
                
                self.weatherCondition = condition
            }
        }
        
    }
}
