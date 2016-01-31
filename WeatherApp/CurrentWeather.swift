//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Ridwan Al-Mansur on 26/01/2016.
//  Copyright © 2016 Ridwan. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    let temperature: Double?
    let location: String?
    
    init(weatherDictionary: [String: AnyObject]) {
        self.temperature = weatherDictionary["max"] as? Double
        self.location = weatherDictionary["name"] as? String
    }
    
    
}