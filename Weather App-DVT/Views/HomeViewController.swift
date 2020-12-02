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
var forecastWeatherViewModel: [ForecastWeatherViewModel] = []

class HomeViewController: UIViewController {

    let locationManager = CLLocationManager()
    var curretLocation: CLLocation!
    
    // MARK: - IBOutlets
    @IBOutlet weak var currentTempValueMain: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherThemeImage: UIImageView!
    
    @IBOutlet weak var currentWeatherBackground: UIView!
    @IBOutlet weak var minTempValue: UILabel!
    @IBOutlet weak var currentTempValue: UILabel!
    @IBOutlet weak var maxTempVlaue: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
                self.getWeatherTodayPlusForecaset()
            } else {
                print("not able")
            }
        }
    }
    
    func getWeatherTodayPlusForecaset(){
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getTodayWeather(at: Coordinate.sharedInstance) {
                [unowned self] currentWeather, error in
                if let currentWeather = currentWeather {
                    todayWeatherViewModel = TodayWeatherViewModel(model: currentWeather)
                    
                    self.displayTodayWeatherData(using: todayWeatherViewModel)
                }
            }
            
            OpenWeatherMapClient.client.getForecastWeather(at: Coordinate.sharedInstance) {
                [unowned self] forecastsWeather, error in
                if let forecastsWeather = forecastsWeather {
                    if forecastsWeather.count > 0 {
                        forecastWeatherViewModel =  []
                    }
                    
                    for forecastWeather in forecastsWeather {
                        let forecastWeatherVM = ForecastWeatherViewModel(model: forecastWeather)
                        forecastWeatherViewModel.append(forecastWeatherVM!)
                        
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func displayTodayWeatherData(using viewModel: TodayWeatherViewModel){
        ConfigureUI(using: viewModel)
        self.currentTempValueMain.text = viewModel.temperature
        self.weatherConditionLabel.text = viewModel.weatherCondition
        
        self.minTempValue.text = viewModel.minTemperature
        self.currentTempValue.text = viewModel.temperature
        self.maxTempVlaue.text = viewModel.maxTemperature
    }
    
    func ConfigureUI(using viewModel: TodayWeatherViewModel){
        
        if viewModel.weatherCondition?.lowercased() == "clouds" {
            weatherThemeImage.image = UIImage(named: Constants.CLOUDY)
            currentWeatherBackground.backgroundColor = Constants.CLOUDY_CL
            tableView.backgroundColor = Constants.CLOUDY_CL
        }
        
        if viewModel.weatherCondition?.lowercased() == "sunny" {
            weatherThemeImage.image = UIImage(named: Constants.SUNNY)
            currentWeatherBackground.backgroundColor = Constants.SUNNY_CL
            tableView.backgroundColor = Constants.SUNNY_CL
        }
        
        if viewModel.weatherCondition?.lowercased() == "rainy" {
            weatherThemeImage.image = UIImage(named: Constants.CLOUDY)
            currentWeatherBackground.backgroundColor = Constants.RAINY_CL
            tableView.backgroundColor = Constants.RAINY_CL
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

// MARK: - Extension - CLLocation delegate

extension HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Coordinate.sharedInstance.latitude      = (manager.location?.coordinate.latitude)!
        Coordinate.sharedInstance.longitude     = (manager.location?.coordinate.longitude)!
        
        self.getWeatherTodayPlusForecaset()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        Coordinate.checkForGrantedLocationPermissions() { allowed in
            if !allowed {
                print("not able")
            }
            
        }
    }
    
}

// MARK: - Extension - UITableViewDelegate and DataSource
extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastWeatherViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecasteWeatherViewModel = forecastWeatherViewModel[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayTableViewCell.identifier, for: indexPath) as! ForecastDayTableViewCell
        //cell.items = forecastWeatherViewModel.
        cell.day.text = forecasteWeatherViewModel.weekday
        cell.taperature.text = forecasteWeatherViewModel.temperature
        
        return cell
    }
    
    
}
