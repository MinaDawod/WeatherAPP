//
//  AlertDisplayer.swift
//  WeatherApp
//
//  Created by Mina Dawood on 16/05/2024.
//

import Foundation
import UIKit

protocol AlertDisplayer {
    func showAlert()
        
    }


func showAlert() {
    
    let alert = UIAlertController(title: "Alert", message: "Please enable location access to use our app services ", preferredStyle: .alert)
    let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: nil)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alert.addAction(acceptAction)
    alert.addAction(cancelAction)
    alert.present(alert, animated: true)
}
//    
