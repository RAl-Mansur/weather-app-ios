//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Ridwan Al-Mansur on 26/01/2016.
//  Copyright © 2016 Ridwan. All rights reserved.
//

import Foundation

struct WeatherService {
    
    let weatherAPIKey: String
    let long: Double
    let lat: Double
    let weatherBaseURL: NSURL?
    
    
    init(apiKey: String, longitude: Double, latitude: Double) {
        self.weatherAPIKey = apiKey
        self.long = longitude
        self.lat = latitude
        
        self.weatherBaseURL = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(long)&cnt=10&mode=json&appid=\(weatherAPIKey)")
        
    }
    
    func getForecast(completion: (Forecast? -> Void)) {
        let networkOperation = NetworkConfiguration(url: weatherBaseURL!)
        networkOperation.downloadJSONFromURL {
            (let jsonDictionary) in
            let forecast = Forecast(weatherDictionary: jsonDictionary)
            completion(forecast)
        }
    }
    
    func getLocation(completion: (CurrentWeather? -> Void)) {
        let networkOperation = NetworkConfiguration(url: weatherBaseURL!)
        networkOperation.downloadJSONFromURL {
            (let jsonDictionary) in
            let currentLocation = self.currentLocationFromJSON(jsonDictionary)
            completion(currentLocation)
        }
    }
    
    func currentLocationFromJSON(jsonDictionary: [String: AnyObject]?) -> CurrentWeather? {
        if let currentLocationDictionary = jsonDictionary?["city"] as? [String: AnyObject] {
            return CurrentWeather(weatherDictionary: currentLocationDictionary)
        } else {
            print("JSON dictionary return nil for city dictionary")
            return nil
        }
    }
    
    func currentWeatherFromJSON(jsonDictionary: [String: AnyObject]?) -> CurrentWeather? {
        if let currentWeatherMain = jsonDictionary?["list"] as? NSArray {
            if let currentWeatherDictionary = currentWeatherMain[0] as? [String: AnyObject] {
                if let currentWeatherTemp = currentWeatherDictionary["temp"] as? [String: AnyObject] {
                    return CurrentWeather(weatherDictionary: currentWeatherTemp)
                }
                return nil
            } else {
                print("Error not found in JSON Dictionary")
            }
            return nil
        } else {
            print("List not found in JSON Dictionary")
            return nil
        }
    }
}









