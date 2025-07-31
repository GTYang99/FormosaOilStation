//
//  File.swift
//  Project
//
//  Created by GTY on 2025/4/17.
//

import Foundation
import MapKit


class FormosaViewModel: NSObject,  CLLocationManagerDelegate {
    var decoderCallBack: ((OilStations) -> Void)?
    var locationCallBack: ((CLLocation) -> Void)?
    var dataJSON: OilStations?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            MainManager.shared.currentLocation = currentLocation
        }
    }
    
    func parserGeoJSONPoint() -> [StagtionMKA]? {
        let extensionName: String = "geojson"
        let fileName = "fpccOilStation"

        var geoJson = [MKGeoJSONObject]()
        let mkGeojsonDecoder = MKGeoJSONDecoder()
        let jsonDecoder = JSONDecoder()
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionName) else {
            fatalError("Unable to get geojson")
        }
        do {
            // Binary data
            let data = try Data(contentsOf: url)
            do {
                let oilStations = try jsonDecoder.decode(OilStations.self, from: data)
                
                let pointAnnotations = oilStations.features?.compactMap({ feature in
                    StagtionMKA(feature: feature)
                })
                dataJSON = oilStations
/*
                let pointAnnotations = geoJson.map {
                    StagtionMKA(geoJSON: $0 as! MKGeoJSONFeature)
                }
*/
                decoderCallBack?(oilStations)
                return pointAnnotations
            } catch {
                print("❗️GeoJSON 解碼失敗：\(error.localizedDescription)")
                fatalError("Unable to decode GeoJSON")
            }
        } catch {
            fatalError("Unable to trans to binary data")
        }
    }
    
    func sortFeaturesByDistance(_ features: [Feature]) -> [Feature] {
        guard let userLocation = self.currentLocation else {
            return features
        }
        let sortedFeatures = features.sorted { (featureA, featureB) -> Bool in
            guard
                let coordA = featureA.coordinate,
                let coordB = featureB.coordinate
            else { return false }

            let locationA = CLLocation(latitude: coordA.latitude, longitude: coordA.longitude)
            let locationB = CLLocation(latitude: coordB.latitude, longitude: coordB.longitude)
            return locationA.distance(from: userLocation) < locationB.distance(from: userLocation)
        }

        return sortedFeatures
    }
    
    func distanceString(_ features: Feature) -> FeatureWithDistance? {
        guard let lat = features.coordinate?.latitude,
              let long = features.coordinate?.longitude else { return nil }
        let stationLoc = CLLocation(latitude: lat, longitude: long)
        let distance = MainManager.shared.locationManager.location?.distance(from: stationLoc)
        let featureWithDistance = FeatureWithDistance(feature: features, distance: distance ?? 0)
        return featureWithDistance
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
        locationCallBack?(location)
        self.locationManager.stopUpdatingLocation()
    }
    
    func filter(/*brands: [加油站廠牌], fuelType: [String], time: [String], distance: Double*/) {
        let data = dataJSON?.features
        let brands = ["全國", "台亞"]
        let result = data?.filter({ feature in
            for brand in brands {
                feature.properties?.站名?.contains(brand) ?? false
            }
            return true
        })
    }
}


struct FeatureWithDistance {
    let feature: Feature
    let distance: Double
}

