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
}
