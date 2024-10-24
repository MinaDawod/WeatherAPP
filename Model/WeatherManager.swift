//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Mina Dawood on 13/05/2024.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(data: WeatherData)
    func didFailWithError(error: Error)
}

class WeatherManager {
    
   
    var delegate: WeatherManagerDelegate?
   
    
    func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                print(response ?? "")
                
                guard error == nil else { return }
                
                guard let weatherData = self.parseJSON(data: data) else { return }
                
                DispatchQueue.main.async {
                    self.delegate?.didUpdateWeather(data: weatherData)
                }
            }
            
            task.resume()
        }
    }
    
    // get weather by cityName
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(Constants.baseUrlString)&q=\(cityName)"
        performRequest(urlString: urlString)
    
    }
    
    // get weather by longitude and latitude
    
    func fetchWeather(longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        
        let urlString = "\(Constants.baseUrlString)&lon=\(longitude)&lat=\(latitude)"
        performRequest(urlString: urlString)
    
    }
    
//    get weather by date and Time
    
    func fetchWeather(date: String) {
        
    }
    
    
    func parseJSON(data: Data?) -> WeatherData? {
        guard let data = data else { return nil }
                
        let stringResponse = String.init(data: data, encoding: .utf8)
        guard let jsonData = stringResponse?.data(using: .utf8) else {
            print("Nil value!")
            return nil
        }
        
        do {
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: jsonData)
            return decodedData
    
        } catch {
            print("Error!")
            return nil
        }
        
    }
}
