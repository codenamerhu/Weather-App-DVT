//
//  OpenWeatherMapClient.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherMapClient {
    static let client = OpenWeatherMapClient()
    
    lazy var baseUrl: URL = {
        return URL(string: Constants.API_BASE_URL)!
    }()
    
    typealias TodayWeatherCompletionHandler  = (TodayWeather?, OpenWeatherMapError) -> Void
    
    func getTodayWeather(at coordinate: Coordinate, completionHandler completion: @escaping TodayWeatherCompletionHandler) {
        
        guard let url = URL(string: Constants.API_ENDPOINT_CURRENT_WEATHER, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        
        
    }
}
