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
    
    var daysArray = [String]()
    var today = ""
    
    var forecastWeatherViewModel: [ForecastWeatherViewModel] = []
    
    var weatherCon = ""
    
    
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
        ConfigureUI(using: viewModel)
        self.currentTempValueMain.text = viewModel.temperature
        self.weatherConditionLabel.text = viewModel.weatherCondition
        
        self.minTempValue.text = viewModel.minTemperature
        self.currentTempValue.text = viewModel.temperature
        self.maxTempVlaue.text = viewModel.maxTemperature
    }
    
    func ConfigureUI(using viewModel: TodayWeatherViewModel){
        
        weatherCon = (viewModel.weatherCondition?.lowercased())!
        
        
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
            weatherThemeImage.image = UIImage(named: Constants.CLOUDY)
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
        print("row count \(self.forecastWeatherViewModel.count)")
        
        return self.forecastWeatherViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if indexPath.row > forecastWeatherViewModel.count - 1{
            return UITableViewCell()
        } else {
            // check if day exists in arraydaysArray.append(forecasteWeatherViewModel.weekday!)
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayTableViewCell.identifier, for: indexPath) as! ForecastDayTableViewCell
                let forecasteWeatherViewModel = forecastWeatherViewModel[indexPath.row]
                print("row \(forecastWeatherViewModel[indexPath.row])")
            
                //cell.items = forecastWeatherViewModel.
                daysArray.append(forecasteWeatherViewModel.weekday!)
                cell.day.text = forecasteWeatherViewModel.weekday
                cell.taperature.text = forecasteWeatherViewModel.temperature
            
            let weatherConditionIs = WeatherCondition.init(rawValue: weatherCon)
            
            switch weatherConditionIs {
            case .sunny:
                cell.contentView.backgroundColor = Constants.SUNNY_CL
                cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                
            case .clear:
                cell.contentView.backgroundColor = Constants.SUNNY_CL
                cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
                
            case .clouds:
                cell.contentView.backgroundColor = Constants.CLOUDY_CL
                cell.icon.image = UIImage(named: Constants.CLOUDS_ICON)
                
            case .rain:
                cell.contentView.backgroundColor = Constants.RAINY_CL
                cell.icon.image = UIImage(named: Constants.RAIN_ICON)
            
            case .none:
                cell.contentView.backgroundColor = Constants.SUNNY_CL
                cell.icon.image = UIImage(named: Constants.SUNNY_ICON)
            }
            
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > forecastWeatherViewModel.count - 1{
            
        } else {
            // check if day exists in arraydaysArray.append(forecasteWeatherViewModel.weekday!)
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayTableViewCell.identifier, for: indexPath) as! ForecastDayTableViewCell
                let forecasteWeatherViewModel = forecastWeatherViewModel[indexPath.row]
                print("row \(forecastWeatherViewModel[indexPath.row])")
            
                //cell.items = forecastWeatherViewModel.
                daysArray.append(forecasteWeatherViewModel.weekday!)
                cell.day.text = forecasteWeatherViewModel.weekday
                cell.taperature.text = forecasteWeatherViewModel.temperature
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        getWeatherTodayPlusForecaset()
    }
    
    
}
