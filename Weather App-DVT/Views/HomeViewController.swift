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
import SkeletonView

var todayWeatherViewModel: TodayWeatherViewModel!


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
    
    @IBOutlet weak var cityName: UILabel!
    
    var daysArray = [String]()
    var today = ""
    
    var forecastWeatherViewModel: [ForecastWeatherViewModel] = []
    
    var weatherCon = ""
    
    var dayForecastWeatherLocal = [String]()
    var conditionForecastWeatherLocal = [String]()
    var tempForecastWeatherLocal = [String]()
    
    let userDef = UserDefaults.standard
    
    var hasInternet: Bool?
    
    var lat: Double?
    var lon: Double?
    
    
    
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
            hasInternet = true
            self.checkPermissions()
        } else {
            hasInternet = false
            displayOfflineWeather()
            dayForecastWeatherLocal = userDef.stringArray(forKey: "day") ?? [String]()
            conditionForecastWeatherLocal = userDef.stringArray(forKey: "condition") ?? [String]()
            tempForecastWeatherLocal = userDef.stringArray(forKey: "temp") ?? [String]()
            tableView.reloadData()
            self.alertInternetAccessNeeded()
        }
        
        print("has internet? \(hasInternet!)")
    }
    
    
    func checkPermissions(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Coordinate.checkForGrantedLocationPermissions() { [unowned self] allowed in
            if allowed {
                
                if self.locationManager.location?.coordinate.latitude == nil{
                    
                    Coordinate.sharedInstance.latitude      = -26.010890128682234
                    Coordinate.sharedInstance.longitude     = 27.994307160254642
                } else {
                    Coordinate.sharedInstance.latitude      = (self.locationManager.location?.coordinate.latitude)!
                    Coordinate.sharedInstance.longitude     = (self.locationManager.location?.coordinate.longitude)!
                }
            
               self.getWeatherTodayPlusForecaset()
            } else {
                print("not able")
            }
        }
    }
    
    func getWeatherTodayPlusForecaset(){
        
        print("co's are \(Coordinate.sharedInstance)")
        
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getTodayWeather(at: Coordinate.sharedInstance) {
                [unowned self] currentWeather, error in
                if let currentWeather = currentWeather {
                    todayWeatherViewModel = TodayWeatherViewModel(model: currentWeather)
                    self.today = todayWeatherViewModel.day!
                    
                    self.displayTodayWeatherData(using: todayWeatherViewModel)
                }
            }
            
            OpenWeatherMapClient.client.getForecastWeather(at: Coordinate.sharedInstance) {
                [unowned self] forecastsWeather, error in
                if let forecastsWeather = forecastsWeather {
                    if forecastsWeather.count > 0 {
                        self.forecastWeatherViewModel =  []
                    }
                    
                    for forecastWeather in forecastsWeather {
                        let forecastWeatherVM = ForecastWeatherViewModel(model: forecastWeather)
                        
                        //print("forre \(forecastWeatherVM)")
                        
                        
                        // Show only 5 days && Skip Today
                        if self.daysArray.contains((forecastWeatherVM?.weekday)!) || (forecastWeatherVM?.weekday)! == self.today {
                            
                        } else {
                            self.daysArray.append((forecastWeatherVM?.weekday)!)
                            self.forecastWeatherViewModel.append(forecastWeatherVM!)
                            self.tableView.reloadData()
                        }
                        
                        
                        
                    }
                }
            }
            
        }
    }
    
    func displayTodayWeatherData(using viewModel: TodayWeatherViewModel){
        ConfigureUI(weatherCondition: viewModel.weatherCondition!)
        saveWeatherTodayLocally(using: viewModel)
        
        self.currentTempValueMain.text = viewModel.temperature
        self.weatherConditionLabel.text = viewModel.weatherCondition
        
        self.minTempValue.text = viewModel.minTemperature
        self.currentTempValue.text = viewModel.temperature
        self.maxTempVlaue.text = viewModel.maxTemperature
        self.cityName.text = viewModel.city
    }
    
    func ConfigureUI(weatherCondition: String){
        
        weatherCon = weatherCondition.lowercased()
        
        
        
        let weatherConditionIs = WeatherCondition.init(rawValue: weatherCon)
        
        switch weatherConditionIs {
        case .sunny:
            weatherThemeImage.image = UIImage(named: Constants.SUNNY)
            currentWeatherBackground.backgroundColor = Constants.SUNNY_CL
            tableView.backgroundColor = Constants.SUNNY_CL
            
            ForecastDayTableViewCell().contentView.backgroundColor = Constants.SUNNY_CL
            
        case .clear:
            weatherThemeImage.image = UIImage(named: Constants.SUNNY)
            currentWeatherBackground.backgroundColor = Constants.SUNNY_CL
            tableView.backgroundColor = Constants.SUNNY_CL
            
            ForecastDayTableViewCell().contentView.backgroundColor = Constants.SUNNY_CL
            
        case .clouds:
            weatherThemeImage.image = UIImage(named: Constants.CLOUDY)
            currentWeatherBackground.backgroundColor = Constants.CLOUDY_CL
            tableView.backgroundColor = Constants.CLOUDY_CL
            
            ForecastDayTableViewCell().contentView.backgroundColor = Constants.CLOUDY_CL
            
        case .rain:
            weatherThemeImage.image = UIImage(named: Constants.RAINY)
            currentWeatherBackground.backgroundColor = Constants.RAINY_CL
            tableView.backgroundColor = Constants.RAINY_CL
            
            ForecastDayTableViewCell().contentView.backgroundColor = Constants.RAINY_CL
        
        case .none:
            weatherThemeImage.image = UIImage(named: Constants.SUNNY)
            currentWeatherBackground.backgroundColor = Constants.SUNNY_CL
            tableView.backgroundColor = Constants.SUNNY_CL
            
            ForecastDayTableViewCell().contentView.backgroundColor = Constants.SUNNY_CL
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
    
    
    func saveWeatherTodayLocally(using viewModel: TodayWeatherViewModel){
        
        userDef.set(viewModel.day, forKey: "currentDay")
        userDef.set(viewModel.city, forKey: "city")
        userDef.set(viewModel.temperature, forKey: "currentTemp")
        userDef.set(viewModel.weatherCondition, forKey: "currentCondition")
        userDef.set(viewModel.minTemperature, forKey: "min")
        userDef.set(viewModel.city, forKey: "city")
        userDef.set(viewModel.maxTemperature, forKey: "max")
        
    }
    
    func saveWeatheForecastLocally(using viewModel: ForecastWeatherViewModel){
        
        // saves days of the week
        dayForecastWeatherLocal.append(viewModel.weekday!)
        conditionForecastWeatherLocal.append(viewModel.weatherCondition!)
        tempForecastWeatherLocal.append(viewModel.temperature!)
        
        userDef.set(dayForecastWeatherLocal, forKey: "day")
        userDef.set(conditionForecastWeatherLocal, forKey: "condition")
        userDef.set(tempForecastWeatherLocal, forKey: "temp")
        
    }
    
    func displayOfflineWeather(){
        ConfigureUI(weatherCondition: userDef.string(forKey: "currentCondition")!)
        weatherCon = userDef.string(forKey: "currentCondition")!
        self.currentTempValueMain.text = userDef.string(forKey: "currentTemp")
        self.weatherConditionLabel.text = userDef.string(forKey: "currentCondition")
        
        self.minTempValue.text = userDef.string(forKey: "min")
        self.currentTempValue.text = userDef.string(forKey: "currentTemp")
        self.maxTempVlaue.text = userDef.string(forKey: "max")
        self.cityName.text = userDef.string(forKey: "city")
    }

}

// MARK: - Extension - CLLocation delegate

extension HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if self.locationManager.location?.coordinate.latitude == nil {
            
            Coordinate.sharedInstance.latitude      = -26.010890128682234
            Coordinate.sharedInstance.longitude     = 27.994307160254642
        } else {
            Coordinate.sharedInstance.latitude      = (manager.location?.coordinate.latitude)!
            Coordinate.sharedInstance.longitude     = (manager.location?.coordinate.longitude)!
        }
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
        var count = 0
        if hasInternet == true {
            count = self.forecastWeatherViewModel.count
        } else {
            count = dayForecastWeatherLocal.count
        }
        print("row count \(count)")
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayTableViewCell.identifier, for: indexPath) as! ForecastDayTableViewCell
        
        
        if hasInternet == true {
            
            
            if indexPath.row > forecastWeatherViewModel.count - 1{
                return UITableViewCell()
            } else {
                
                let forecasteWeatherViewModel = forecastWeatherViewModel[indexPath.row]
                print("row \(forecastWeatherViewModel[indexPath.row])")
                // check if day exists in arraydaysArray.append(forecasteWeatherViewModel.weekday!)
                
                
                    //cell.items = forecastWeatherViewModel.
                self.saveWeatheForecastLocally(using: forecasteWeatherViewModel)
                    daysArray.append(forecasteWeatherViewModel.weekday!)
                    cell.day.text = forecasteWeatherViewModel.weekday
                    cell.taperature.text = forecasteWeatherViewModel.temperature
                
                print("con is \(forecasteWeatherViewModel.weatherCondition!)")
                
                // Set dayofWeek Icon Image
                let dayOfWeekWeatherCondition = WeatherCondition.init(rawValue: forecasteWeatherViewModel.weatherCondition!.lowercased())
                
                switch dayOfWeekWeatherCondition {
                case .sunny:
                    cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                    
                case .clear:
                    cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                    
                case .clouds:
                    cell.icon.image = UIImage(named: Constants.CLOUDS_ICON)
                    
                case .rain:
                    cell.icon.image = UIImage(named: Constants.RAIN_ICON)
                
                case .none:
                    cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                }
                
                // Change contentView background color to today weather condition color
                let weatherConditionIs = WeatherCondition.init(rawValue: weatherCon.lowercased())
                
                switch weatherConditionIs {
                case .sunny:
                    cell.contentView.backgroundColor = Constants.SUNNY_CL
                    
                case .clear:
                    cell.contentView.backgroundColor = Constants.SUNNY_CL
                    
                case .clouds:
                    cell.contentView.backgroundColor = Constants.CLOUDY_CL
                    
                case .rain:
                    cell.contentView.backgroundColor = Constants.RAINY_CL
                
                case .none:
                    cell.contentView.backgroundColor = Constants.SUNNY_CL
                }
                
            }
        } else {
            
            // check if day exists in arraydaysArray.append(forecasteWeatherViewModel.weekday!)
                           
                               //cell.items = forecastWeatherViewModel.
                              // daysArray.append(forecasteWeatherViewModel.weekday!)
            cell.day.text = dayForecastWeatherLocal[indexPath.row]
            cell.taperature.text = tempForecastWeatherLocal[indexPath.row]
                           
                           // Set dayofWeek Icon Image
            let dayOfWeekWeatherCondition = WeatherCondition.init(rawValue: conditionForecastWeatherLocal[indexPath.row].lowercased())
                           
                           switch dayOfWeekWeatherCondition {
                           case .sunny:
                               cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                               
                           case .clear:
                               cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                               
                           case .clouds:
                               cell.icon.image = UIImage(named: Constants.CLOUDS_ICON)
                               
                           case .rain:
                               cell.icon.image = UIImage(named: Constants.RAIN_ICON)
                           
                           case .none:
                               cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                           }
                           
            
                           // Change contentView background color to today weather condition color
                           let weatherConditionIs = WeatherCondition.init(rawValue: weatherCon.lowercased())
                           
                           switch weatherConditionIs {
                           case .sunny:
                               cell.contentView.backgroundColor = Constants.SUNNY_CL
                               
                           case .clear:
                               cell.contentView.backgroundColor = Constants.SUNNY_CL
                               
                           case .clouds:
                               cell.contentView.backgroundColor = Constants.CLOUDY_CL
                               
                           case .rain:
                               cell.contentView.backgroundColor = Constants.RAINY_CL
                           
                           case .none:
                               cell.contentView.backgroundColor = Constants.SUNNY_CL
                           } 
                           
                           
                           
            
        }
        return cell
       
    }
    
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > forecastWeatherViewModel.count - 1{
            
        } else {
            // check if day exists in arraydaysArray.append(forecasteWeatherViewModel.weekday!)
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayTableViewCell.identifier, for: indexPath) as! ForecastDayTableViewCell
                let forecasteWeatherViewModel = forecastWeatherViewModel[indexPath.row]
                print("row \(forecastWeatherViewModel[indexPath.row])")
                self.saveWeatheForecastLocally(using: forecasteWeatherViewModel)
                //cell.items = forecastWeatherViewModel.
                daysArray.append(forecasteWeatherViewModel.weekday!)
                cell.day.text = forecasteWeatherViewModel.weekday
                cell.taperature.text = forecasteWeatherViewModel.temperature
        }
    } */
    
    
}
