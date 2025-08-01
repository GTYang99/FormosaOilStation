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
    var filterCallBack: (([FeatureWithDistance]) -> Void)?
    var locationCallBack: ((CLLocation) -> Void)?
    var dataJSON: OilStations?
    //var filterData: OilStations?
    //var nearData: OilStations?
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
                dataJSON = oilStations
                decoderCallBack?(oilStations)
                if let features = oilStations.features {
                    let pointAnnotations = transToMKA(features)
                    return pointAnnotations
                } else {
                    return nil
                }
            } catch {
                print("❗️GeoJSON 解碼失敗：\(error.localizedDescription)")
                fatalError("Unable to decode GeoJSON")
            }
        } catch {
            fatalError("Unable to trans to binary data")
        }
    }
    
    func transToMKA(_ feature: [Feature]) -> [StagtionMKA]?{
        let mka = feature.compactMap({ feature in
            StagtionMKA(feature: feature)
        })
        return mka
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
    
    func distanceFeatures(_ features: [Feature], near km: Double) -> [FeatureWithDistance] {
        let nearKM = km * 1000
        let distanceFeatures = features.compactMap { feature -> FeatureWithDistance? in
            guard let coord = feature.coordinate,
                  let userLoc = currentLocation else { return nil }

            let stationLoc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let distance = userLoc.distance(from: stationLoc)
            return  distance <= nearKM ? FeatureWithDistance(feature: feature, distance: distance): nil
        }
        return distanceFeatures
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
    
    func filterCondition(brands: [加油站廠牌], fuelType: [String], time: [Date?], distance: Double) {
        let data = dataJSON?.features
        let result = data?.filter({ feature in
            guard let properties = feature.properties else { return false}
            var resultBrand = false
            var resultFuelType = false
            var resultTime = false
            
            if brands.isEmpty {
                resultBrand = true
            } else {
                resultBrand = brands.contains(where: { properties.站名?.contains( $0.rawValue ) == true })
            }
            
            if fuelType.isEmpty {
                resultFuelType = true
            } else {
                resultFuelType = fuelType.contains { fuel in
                    if fuel == "92" && (properties.the92無鉛 == true || properties.fuel92 == true) {
                        return true
                    }
                    if fuel == "95" && (properties.the95Plus無鉛 == true || properties.fuel95 == true) {
                        return true
                    }
                    if fuel == "98" && (properties.the98無鉛 == true || properties.fuel98 == true) {
                        return true
                    }
                    if fuel == "柴油" , properties.超級柴油 == true {
                        return true
                    } else {
                        return false
                    }
                }
            }
            
            if time.isEmpty {
                resultTime = true
            } else {
                resultTime = time.enumerated().contains { index, time in
                    
                    if properties.營業時間 == "24小時" {
                        return true
                    }
                    guard let 營業時間 = properties.營業時間, 營業時間.count > 6, let time = time else { return  false }
                    let (open, close) = transfromTime(times: 營業時間)
                    if let open = open , let close = close {
                        return open <= time && time >= close
                    }
                    
                    if let open = open {
                        return open <= time
                    }

                    if let close = close {
                        return time >= close
                    }
                    return false
                    
                }
            }
            
            return resultBrand && resultFuelType && resultTime
        })
        
        
        guard let result = result else { return }
        let resultDistance = distanceFeatures(result, near: distance)
        filterCallBack?(resultDistance)
    }
    
    private func transfromTime(times: String) -> (open: Date?, close: Date?) {
        let splitSymbol = "\(times.index(times.startIndex, offsetBy: 6))"
        let timeArray = times.components(separatedBy: splitSymbol)
        //print(timeArray)
        guard timeArray.count == 2 else { return (nil, nil) }
        
        return (
            DateManager.shared.stringToTime(from: String(timeArray[0])),
            DateManager.shared.stringToTime(from: String(timeArray[1]))
        )
    }
    
}


struct FeatureWithDistance {
    let feature: Feature
    let distance: Double
}

