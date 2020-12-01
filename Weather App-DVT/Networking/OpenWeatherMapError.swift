//
//  OpenWeatherMapError.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation

enum OpenWeatherMapError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case invalidUrl
    case jsonParsingFailure
    case noError
}
