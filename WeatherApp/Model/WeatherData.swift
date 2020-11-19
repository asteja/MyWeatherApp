//
//  MasterModel.swift
//  WeatherApp
//
//  Created by Saiteja Alle on 8/17/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    
    var city: String?
    var tempData:[String:Double]?

    enum CodingKeys: String, CodingKey {
        case city = "name"
        case tempData = "main"
    }
    
}

