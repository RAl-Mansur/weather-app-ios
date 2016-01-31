//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Ridwan Al-Mansur on 26/01/2016.
//  Copyright © 2016 Ridwan. All rights reserved.
//

import Foundation


struct DailyWeather {
    
    let maxTemperature: Double?
    var day: String?
    let dateFormatter = NSDateFormatter()
    
    init(dailyWeatherDictionary: [String: AnyObject]) {
        let temp = dailyWeatherDictionary["temp"]?["max"] as? Double
        self.maxTemperature = (round(1000*(temp! - 273.15))/1000)

        if let time = dailyWeatherDictionary["dt"] as? Double {
            self.day = dayStringFromTime(time)
        }
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
}