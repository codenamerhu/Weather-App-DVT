//
//  OpenWeatherMapClient.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation

class OpenWeatherMapClient {
    static let client = OpenWeatherMapClient()
    
    lazy var baseUrl: URL = {
        return URL(string: Constants.API_BASE_URL)!
    }()
    
    typealias TodayWeatherCompletionHandler  = (TodayWeather?)
}
