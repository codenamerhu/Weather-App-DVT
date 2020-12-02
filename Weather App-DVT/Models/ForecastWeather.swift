//
//  ForecastWeather.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/02.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation

struct ForecastWeather {
    var date: Double = Double.infinity
    var temperature: Double = Double.infinity
    var weatherCondition: String = ""
}

extension ForecastWeather {
    
    struct Key {
        static let date = "dt"
        
        // MARK:- Temp
        static let tempKey = "main"
        static let temparatureDay = "temp"
        
        // MARK:- Weather[0]
        static let weatherKey = "weather"
        static let weatherCondition  = "main"
    }
    
    init?(dataInJson: [String: AnyObject]) {
        
        if let dateValue = dataInJson[Key.date] as? Double {
            self.date = dateValue
        }
        
        if let main = dataInJson[Key.tempKey] as? Dictionary<String, AnyObject> {
            if let temperatureValue = main[Key.temparatureDay] as? Double {
                self.temperature = temperatureValue
            }
        }
        
        if let weather = dataInJson[Key.weatherKey] as? [Dictionary<String, AnyObject>] {
            if let weatherConditionValue = weather[0][Key.weatherCondition] as? String {
                self.weatherCondition = weatherConditionValue
            }
        }
    }
}
