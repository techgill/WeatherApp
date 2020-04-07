//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Gill Hardeep on 07/04/20.
//  Copyright © 2020 Gill Hardeep. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager{
    
    let url = "https://api.openweathermap.org/data/2.5/weather?id=524901&APPID=fec2fe10750f06b18907eba3c724a172&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(url)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees ){
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        // these are the steps for networking using url session or to get data from web server using api or fetching data.
        // 1. create a url
        if let url = URL(string: urlString){
            
            // 2. create a url session.
            let session = URLSession(configuration: .default)
            
            // 3. give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data{
//                    let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
//                    weather[0].description
                }
            }
            
            // 4. start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temperature = decodedData.main.temp
//            let description = decodedData.weather[0].description
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(id: id, name: name, temperature: temperature)
//            print(weather.conditionName)
//            print(weather.temperatureString)
//            print(weather.name)
            return weather
            
        }catch{
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
    
}
