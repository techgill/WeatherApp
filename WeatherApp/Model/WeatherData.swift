//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Gill Hardeep on 07/04/20.
//  Copyright © 2020 Gill Hardeep. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Double
}

struct Weather: Decodable{
    let description: String
    let id: Int
}
