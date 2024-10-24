//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mina Dawood on 12/05/2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempratureTextLabel: UILabel!
    @IBOutlet weak var humedityTextLabel: UILabel!
    @IBOutlet weak var windSpeedTextLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
    func setDelegates() {
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
    }
    
    @IBAction func didTapLocationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        performSearch()
    }
    
   @objc func dateChanged(_ sender: UIDatePicker) {
        let selectedData = sender.date
        print("selectedData = \(selectedData)")
       
       let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .short
           let formattedDate = formatter.string(from: selectedData)
           print("Formatted date: \(formattedDate)")
       
       
    }
    

    func performSearch() {
        if let cityName = searchTextField.text, !cityName.isEmpty {
            
            weatherManager.fetchWeather(cityName: cityName)
            
        } else {
            searchTextField.placeholder = "Please entra a city name"
        }
    }

}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(data: WeatherData) {
        cityLabel.text = data.name
        tempratureTextLabel.text = data.main?.temp.stringFormat()
        humedityTextLabel.text = data.main?.humidity.stringFormat()
        windSpeedTextLabel.text = data.wind?.speed.stringFormat()
        
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        performSearch()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if  textField.text != "" {
            return true
        } else {
            textField.placeholder = "please entre a city name"
            return false
        }
        
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate, AlertDisplayer {
    func showAlert() {
        print("")
    }
    
   
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            weatherManager.fetchWeather(longitude: lon, latitude: lat)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .notDetermined:
               // The user has not yet made a choice regarding location services
               manager.requestWhenInUseAuthorization()
           case .restricted, .denied:
               // The user has denied or restricted access to location services
               // Handle accordingly, maybe show an alert
               
               
               break
           case .authorizedWhenInUse, .authorizedAlways:
               // The user has authorized access to location services
               manager.startUpdatingLocation()
           @unknown default:
               break
           }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           // Handle location manager errors
           print("Location manager failed with error: \(error)")
           
           
       }
    
}



enum ErrorType {
    case unexpected
    case domain
    case server
    case local
}

// MARK: - Main

extension Optional where Wrapped == Double {
    
    func stringFormat() -> String {
        if let self = self {
            return String(self)
        } else {
            return ""
        }
    }
}

extension Optional where Wrapped == Int {
    
    func stringFormat() -> String {
        if let self = self {
            return String(self)
        } else {
            return ""
        }
    }
}



