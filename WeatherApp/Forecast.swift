//
//  Forecast.swift
//  WeatherApp
//
//  Created by Ridwan Al-Mansur on 26/01/2016.
//  Copyright © 2016 Ridwan. All rights reserved.
//

import Foundation

struct Forecast {
    
    var currentWeather: CurrentWeather?
    var weekly: [DailyWeather] = []
    
    init(weatherDictionary: [String: AnyObject]?) {
        if let currentWeatherMain = weatherDictionary?["list"] as? NSArray {
            if let currentWeatherDictionary = currentWeatherMain[0] as? [String: AnyObject] {
                if let currentWeatherTemp = currentWeatherDictionary["temp"] as? [String: AnyObject] {
                    currentWeather = CurrentWeather(weatherDictionary: currentWeatherTemp)
                }
            }
        }
        if let weeklyWeatherArry = weatherDictionary?["list"] as? [[String: AnyObject]] {
            for dailyWeather in weeklyWeatherArry {
                let daily = DailyWeather(dailyWeatherDictionary: dailyWeather)
                weekly.append(daily)
            }
        }
    }
    
    
}