//
//  ViewController.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/01.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

var todayWeatherViewModel: TodayWeatherViewModel!

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    var curretLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if Connectivity.isConnectedToInternet {
            self.checkPermissions()
        } else {
            self .alertInternetAccessNeeded()
        }
    }
    
    
    func checkPermissions(){
        Coordinate.checkForGrantedLocationPermissions() { [unowned self] allowed in
            if allowed {
                self.getWeatherToday()
            } else {
                print("not able")
            }
        }
    }
    
    func getWeatherToday(){
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getTodayWeather(at: Coordinate.sharedInstance) {
                [unowned self] currentWeather, error in
                if let currentWeather = currentWeather {
                    todayWeatherViewModel = TodayWeatherViewModel(model: currentWeather)
                }
            }
        }
    }

    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    func alertInternetAccessNeeded() {
        
        let alert = UIAlertController(
            title: "Need Interet Access",
            message: "Internet access is required",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    
        present(alert, animated: true, completion: nil)
    }

}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Coordinate.sharedInstance.latitude      = (manager.location?.coordinate.latitude)!
        Coordinate.sharedInstance.longitude     = (manager.location?.coordinate.longitude)!
        
        self.getWeatherToday()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        Coordinate.checkForGrantedLocationPermissions() { allowed in
            if !allowed {
                print("not able")
            }
            
        }
    }
    
}
