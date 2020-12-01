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
    
    // Shared Instances
    static let sharedInstance = Coordinate(latitude: 0.0, longitude: 0.0)
    
    // location manager
    static let locationManager = CLLocationManager()
    
    // location permission check
    typealias CheckLocationPermissionCompletionHandler = (Bool) -> Void
    static func checkForGrantedLocationPermissions(completionHandler completion: @escaping CheckLocationPermissionCompletionHandler) {
        
        let locationPermisionStatusGranted = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        
        if locationPermisionStatusGranted {
            let currentLocation = locationManager.location
            
            print("Coordinates are \(currentLocation?.coordinate.latitude as Any) \(currentLocation?.coordinate.longitude as Any)")
            
        }
    }
    
    
    
    // Longitude and latitude variables
    var latitude: Double
    var longitude: Double
}
