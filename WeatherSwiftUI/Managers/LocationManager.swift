//
//  LocationManager.swift
//  WeatherSwiftUI
//
//  Created by Юра Ганкович on 22.08.23.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location ", error)
        isLoading = false
    }
}
