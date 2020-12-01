//
//  Coordinate.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate {
    static let sharedInstance = Coordinate(latitude: 0.0, longitude: 0.0)
    
    static let locationManager = CLLocationManager()
    
    var latitude: Double
    var longitude: Double
}
