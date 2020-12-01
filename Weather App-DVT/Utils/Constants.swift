//
//  Constants.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation

class Constants {
    
    
    // MARK:- OpenWeatherMap API
    static let API_BASE_URL                     = "https://api.openweathermap.org/data/2.5/"
    static let API_ENDPOINT_CURRENT_WEATHER     = "weather/"
    static let API_ENDPOINT_FORECAST_WEATHER    = "forecast/"
    
    // MARK:- Weater ref properties
    static let WEATHER_CITY         = "city"
    static let WEATHER_TEMP         = "temperature"
    static let WEATHER_CONDITION    = "condition"
    static let DATE                 = "date"
    static let LATITUDE             = "lat"
    static let LONGITUDE            = "lon"
}
