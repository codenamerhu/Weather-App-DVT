//
//  Constants.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    
    // MARK:- OpenWeatherMap API
    static let API_BASE_URL                     = "https://api.openweathermap.org/data/2.5/"
    static let API_ENDPOINT_CURRENT_WEATHER     = "weather/"
    static let API_ENDPOINT_FORECAST_WEATHER    = "forecast/"
    
    static let APP_ID                           = "8f8fa95299448a196bfb45cb8b1fa439"
    
    // MARK:- Weater ref properties
    static let WEATHER_CITY         = "city"
    static let WEATHER_TEMP         = "temperature"
    static let WEATHER_CONDITION    = "condition"
    static let DATE                 = "date"
    static let LATITUDE             = "lat"
    static let LONGITUDE            = "lon"
    
    // MARK:- Images
    static let SUNNY    = "forest_sunny"
    static let CLOUDY   = "forest_cloudy"
    static let RAINY    = "forest_rainy"
    
    // MARK:- Color
    
    static let SUNNY_CL     = UIColor(hex: "#47AB2Fff")
    static let CLOUDY_CL    = UIColor(hex: "#54717Aff")
    static let RAINY_CL     = UIColor(hex: "#57575Dff")
}
