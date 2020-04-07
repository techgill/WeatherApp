//
//  ViewController.swift
//  WeatherApp
//
//  Created by Gill Hardeep on 06/04/20.
//  Copyright © 2020 Gill Hardeep. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // this line is for dismiss keyboard after clicking button.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this function is for using return button in keyboard.
        searchTextField.endEditing(true)// this line is for dismiss keyboard after clicking button.
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // this function is to check user didnot click go button without typing anything in textfield.
        if searchTextField.text != ""{
            return true
        }else{
            searchTextField.placeholder = "type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // this function is to clear textfield after button pressed
        if let cityName = searchTextField.text{
            weatherManager.fetchWeather(cityName: cityName)
        }
        searchTextField.text = ""
    }
}

// MARK:werManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.name
        }
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }
}


// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

