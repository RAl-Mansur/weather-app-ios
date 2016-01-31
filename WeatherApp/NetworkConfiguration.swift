//
//  NetworkConfiguration.swift
//  WeatherApp
//
//  Created by Ridwan Al-Mansur on 26/01/2016.
//  Copyright © 2016 Ridwan. All rights reserved.
//

import Foundation

class NetworkConfiguration {
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    typealias jsonDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: jsonDictionaryCompletion) {
        
        let request:NSURLRequest = NSURLRequest(URL: queryURL)
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            // check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // create JSON object with data
                    do {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                        completion(jsonDictionary)
                    } catch {
                        print("Error loading weather info")
                    }
                default:
                    print("Get Request not successful")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
            
            
            
        }

        dataTask.resume()
        
    }
}