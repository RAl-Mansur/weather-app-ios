//
//  WeeklyTableViewController.swift
//  WeatherApp
//
//  Created by Ridwan Al-Mansur on 26/01/2016.
//  Copyright © 2016 Ridwan. All rights reserved.
//

import UIKit
import Social
import CoreLocation

class WeeklyTableViewController: UITableViewController, CLLocationManagerDelegate {

    let apiKey: String = "246aeca40458f1c37d204fdd0272765d"
    let locationManager = CLLocationManager()
    var lat: Double = 51.51
    var long: Double = -0.09
    var weeklyWeather: [DailyWeather] = []

    
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var longitudeInput: UITextField!
    @IBOutlet weak var latitudeInput: UITextField!
    @IBAction func getWeatherBtn(sender: AnyObject) {
        
        if latitudeInput.text == "" || longitudeInput.text == "" {
            latitudeInput.text = "0.0"
            longitudeInput.text = "0.0"
            self.lat = 0.0
            self.long = 0.0
        } else {
            self.lat = Double(latitudeInput.text!)!
            self.long = Double(longitudeInput.text!)!
        }
        getWeatherUpdate(lat, longitude: long)
    }
    
    // Social settings
    // Share weather and location to twitter
    @IBAction func shareTweet(sender: AnyObject) {
        
        let shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        if let currentTemp = currentTemperatureLabel.text, let currentLocation = currentLocationLabel.text {
            shareToTwitter.setInitialText("The current temperature in \(currentLocation) is \(currentTemp)")
        }
        
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
        
    }
    // Share weather and location to FaceBook
    @IBAction func shareToFB(sender: AnyObject) {
        let shareToFB: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        if let currentTemp = currentTemperatureLabel.text, let currentLocation = currentLocationLabel.text {
            shareToFB.setInitialText("The current temperature in \(currentLocation) is \(currentTemp)")
        }
        self.presentViewController(shareToFB, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get current location
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // Get weather forecast for current location
        getWeatherUpdate(lat, longitude: long)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Use and display current location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        longitudeInput.text = "\(round(100*location.coordinate.longitude)/100)"
        latitudeInput.text = "\(round(100*location.coordinate.latitude)/100)"
        refreshWeather()
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeather.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! DailyWeatherTableViewCell
        
        let dailyWeather = weeklyWeather[indexPath.row]
        //cell.textLabel?.text = dailyWeather.day
        if let maxTemp = dailyWeather.maxTemperature {
            cell.temperatureLabel.text = "\(maxTemp)º"
        }
        
        cell.dayLabel.text = dailyWeather.day
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 61/255.0, green: 50/255.0, blue: 70/255.0, alpha: 1.0)
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
            header.textLabel?.textColor = UIColor.whiteColor()
        }
    }

    // Refresh/Update weather using pull gesture
    @IBAction func refreshWeather() {
        
        if latitudeInput.text == "" || longitudeInput.text == "" {
            latitudeInput.text = "0.0"
            longitudeInput.text = "0.0"
            self.lat = 0.0
            self.long = 0.0
        } else {
            self.lat = Double(latitudeInput.text!)!
            self.long = Double(longitudeInput.text!)!
        }
        getWeatherUpdate(lat, longitude: long)
        refreshControl?.endRefreshing()
    }

    func getWeatherUpdate(latitude: Double, longitude: Double) {
        let weatherService = WeatherService(apiKey: apiKey, longitude: long, latitude: lat)
        // Get weather
        weatherService.getForecast() {
            (let forecast) in
            if let weatherForecast = forecast, let currentWeather = weatherForecast.currentWeather {
                // Update UI
                dispatch_async(dispatch_get_main_queue()) {
                    // Execute closure
                    
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel.text = "\(round(1000*(temperature - 273.15))/1000)º"
                    }
                    
                    self.weeklyWeather = weatherForecast.weekly
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        // Get location
        weatherService.getLocation() {
            (let currently) in
            if let currentLocation = currently {
                dispatch_async(dispatch_get_main_queue()) {
                    if let location = currentLocation.location {
                        self.currentLocationLabel.text = "\(location)"
                    }
                }
            }
        }
    }
    

}
