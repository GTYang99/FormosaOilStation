//
//  MainManager.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/7/29.
//

import Foundation
import UIKit
import MapKit

class MainManager: NSObject,  CLLocationManagerDelegate {
    
    static let shared = MainManager()
    private override init() {
        super.init()
        self.checkFavoriteExiste()
    }
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            locationUpdateHandler?(currentLocation)
        }
    }
    var locationUpdateHandler: ((CLLocation?) -> Void)?
    let key = "favoriteStation"
    let userDefaults = UserDefaults.standard
    
    func transICON(title: String) -> UIImage {
        if title.contains("全國") {
            return UIImage(named: "全國") ?? UIImage()
        }
        else if title.contains("統一") {
            return UIImage(named: "統一") ?? UIImage()
        }
        else if title.contains("福懋") {
            return UIImage(named: "福懋") ?? UIImage()
        }
        else if title.contains("山隆") {
            return UIImage(named: "山隆") ?? UIImage()
        } else {
            return UIImage(named: "logo") ?? UIImage()
        }
    }
    
    func recordLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        currentLocation = location
        self.locationManager.stopUpdatingLocation()
    }
    
    func checkFavoriteExiste() {
        let rawData = [Feature]()
        
        if userDefaults.data(forKey: key) == nil {
            if let encoded = try? JSONEncoder().encode(rawData) {
                userDefaults.set(encoded, forKey: key)
            }
        }
    }
    
    func getFavoriteStations() -> [Feature] {
        guard let data = userDefaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Feature].self, from: data) else {
            return []
        }
        return decoded
    }
    
    func saveFavoriteStations(_ data: Feature) -> Bool {
        var userDefault = getFavoriteStations()
        
        if userDefault.contains(where: { $0.properties?.站名 == data.properties?.站名 }) {
            return false
        }
        userDefault.append(data)
        if let encoder = try? JSONEncoder().encode(userDefault){
            userDefaults.set(encoder, forKey: key)
            return true
        } else {
            return false
        }
    }
    
    func deleteCoverStations(_ datas: [Feature]) -> Bool {
        if let encoder = try? JSONEncoder().encode(datas){
            userDefaults.set(encoder, forKey: key)
            return true
        } else {
            return false
        }
    }
}

