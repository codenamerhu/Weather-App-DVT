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
        
        let params: Parameters = self.buildParameters(coordinate: coordinate)
        
        AF.request(url, parameters: params).responseJSON { response in
            
            guard let JSONData = response.value as? Dictionary<String, AnyObject> else {
                completion(nil, .invalidUrl)
                return
            }
            
            print(JSONData)
            
            if response.response?.statusCode == 200 {
                guard let currentWeather = TodayWeather(dataInJSON: JSONData) else {
                    completion(nil, .jsonParsingFailure)
                    print(JSONData)
                    
                    return
                }
                
                completion(currentWeather, .noError         )
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        
    }
    
    
    func buildParameters(coordinate: Coordinate) -> Parameters {
        let params: Parameters = [
            "appid":Constants.APP_ID,
            "lat":String(coordinate.latitude),
            "lon":String(coordinate.longitude),
            "units":"metric"
        ]
        
        return params
    }
}
