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
    static var sharedInstance = Coordinate(latitude: 0.0, longitude: 0.0)
    
    // location manager
    static let locationManager = CLLocationManager()
    
    // location permission check
    typealias CheckLocationPermissionCompletionHandler = (Bool) -> Void
    static func checkForGrantedLocationPermissions(completionHandler completion: @escaping CheckLocationPermissionCompletionHandler) {
        
        let locationPermisionStatusGranted = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        
        if locationPermisionStatusGranted {
            let currentLocation = locationManager.location
            
            print("Coordinates are \(currentLocation?.coordinate.latitude as Any) \(currentLocation?.coordinate.longitude as Any)")
            
            if(currentLocation?.coordinate.latitude==nil || currentLocation?.coordinate.latitude==nil) {
                print("Simulcation cannot get location")
                Coordinate.sharedInstance.latitude = -26.005506844488554
                Coordinate.sharedInstance.latitude = 28.0839068002685
            } else {
                Coordinate.sharedInstance.latitude = (currentLocation?.coordinate.latitude)!
                Coordinate.sharedInstance.latitude = (currentLocation?.coordinate.longitude)!
            }
            
        }
        
        completion(locationPermisionStatusGranted)
    }
    
    
    
    // Longitude and latitude variables
    var latitude: Double
    var longitude: Double
}
