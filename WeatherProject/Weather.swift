//
//  Weather.swift
//  JSON
//
//  Created by Brian Advent on 11.05.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary:String
    let icon:String
    let temperatureMax:Double
    let temperatureMin:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperatureMax = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        guard let temperatureMin = json["temperatureMin"] as? Double else {throw SerializationError.missing("temp is missing")}
        self.summary = summary
        self.icon = icon
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/4db87fec324b42b4c8172cc9ace1a174/"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"+"?lang=de&units=us"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
        
        
        
        
        
        
        
    
    }
    

}
