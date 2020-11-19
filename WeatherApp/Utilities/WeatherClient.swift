//
//  WeatherApIHelper.swift
//  WeatherApp
//
//  Created by Saiteja Alle on 8/17/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation

enum APIError: String {
    case invalidResponse = "Invalid response"
    case noData = "No Data"
    case failedRequest = "Failed Request"
    case invalidData = "Invalid Data"
    case dataExistsError = "Data Already exists"
    case dataSaveError = "Data Save error"
    case dataFetchError = "Data fetch error"
}

class WeatherClient: NSObject {
        
    typealias WeatherDataCompletion = (WeatherData?, APIError?) -> ()

    func startLoad(zipCode: String?, completion: @escaping WeatherDataCompletion) {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject], let apiKey = dict["APIKey"] as? String, let zipCode = zipCode else {
            return
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=\(zipCode),us&units=imperial&appid=\(apiKey)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
              completion(nil, .failedRequest)
              return
            }
            
            guard let data = data else {
                completion(nil, .noData)
              return
            }
            
            guard let response = response as? HTTPURLResponse else {
              completion(nil, .invalidResponse)
              return
            }
            
            guard response.statusCode == 200 else {
              completion(nil, .failedRequest)
              return
            }
            do {
              let decoder = JSONDecoder()
              let weatherData: WeatherData = try decoder.decode(WeatherData.self, from: data)
              completion(weatherData, nil)
            } catch {
              completion(nil, .invalidData)
            }
        }.resume()
    }
    
}
