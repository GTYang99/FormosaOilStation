//
//  File.swift
//  Project
//
//  Created by GTY on 2025/4/17.
//

import Foundation
import MapKit
import SwiftSoup
import GooglePlaces


class FormosaViewModel: NSObject,  CLLocationManagerDelegate {
    var decoderCallBack: ((OilStations) -> Void)?
    var filterCallBack: (([FeatureWithDistance]) -> Void)?
    var locationCallBack: ((CLLocation) -> Void)?
    var fuelPriceCallBack: (([油種: Double], String) -> Void)?
    var newsCallBack: (() -> Void)?
    
    var dataJSON: OilStations?
    var filterData: OilStations?
    var filterDistance: Double?
    var newsData: [NewsResponse]?
    
    let locationManager = CLLocationManager()
    let placesClient = GMSPlacesClient.shared()
    var imageCallBack: ((UIImage) -> Void)?
    var imageFetchError: (() -> Void)?
    
    var currentLocation: CLLocation? {
        didSet {
            MainManager.shared.currentLocation = currentLocation
        }
    }
    
    func parserGeoJSONPoint() -> [StagtionMKA]? {
        let extensionName: String = "geojson"
        let fileName = "fpccOilStation_place_id"

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
    
    func distanceFeatures(_ features: [Feature], near km: Double = 10.0) -> [FeatureWithDistance] {
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
        filterData = OilStations(type: "Feature", features: result)
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
    
    
    func fetchMainHTML(_ api: ConnectAPI.ParserURL) {
        let task = URLSession.shared.dataTask(with: api.url) { data, response, error in
            if let data = data, let html = String(data: data, encoding: .utf8) {
                switch api {
                case .fuelPrice:
                    self.parseFuelHTML(html)
                case .news:
                    self.parseNewsHTML(html)
                }
            }
        }

        task.resume()
    }

    private func parseFuelHTML(_ html: String) {
        do {
            var resultDict = [油種: Double]()
            var resultDate = ""
            let doc: Document = try SwiftSoup.parse(html)
            let blocks: Elements = try doc.select("div.price-block")
            
            for block in blocks {
                let h3 = try block.select("h3").first()?.text() ?? ""
                if h3.contains("加盟") {
                    let prices = try block.select("div.gas-price div")
                    let itemDate = try block.select("p").text().components(separatedBy: " ")
                    let date = "\(itemDate[2])\(itemDate[3])"
                    resultDate = date
                    for price in prices {
                        let fuel = try price.text()
                        var fuelTitle: 油種?
                        let item = fuel.components(separatedBy: " ").last ?? ""
                        if item.contains("92") {
                            fuelTitle = .fuel92
                        } else if item.contains("95") {
                            fuelTitle = .fuel95
                        } else if item.contains("98") {
                            fuelTitle = .fuel98
                        } else if item.contains("柴油") {
                            fuelTitle = .fuel柴油
                        }
                        let fuelPrice = Double(fuel.components(separatedBy: " ").first?.replacingOccurrences(of: "$", with: "") ?? "") ?? 0.0
                        if let fuelTitle = fuelTitle{
                            resultDict[fuelTitle] = fuelPrice
                        }
                    }
                }
            }
            fuelPriceCallBack?(resultDict, resultDate)
        } catch {
            print("解析失敗：\(error)")
        }
    }
    
    private func parseNewsHTML(_ html: String) {
        var dataSet = [NewsResponse]()
        let dispatch = DispatchGroup()
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let blocks: Elements = try doc.select("div.news-list")
            for block in blocks {
                let items = try block.select("li")
                for item in items {
                    let stringDate = try item.select("span").text()
                    let date = DateManager.shared.engStringToDate(from: stringDate)
                    
                    print("\(stringDate),\(date)")
                    
                    guard let date = date  else { continue }
                    let title = try item.select("p").text()
                    let urlString = try item.select("a").attr("href")
                    var increase: Bool = false
                    dispatch.enter()
                    getIncreasePrice(form: urlString) { result in
                        increase = result == "調漲" ? true : false
                        let news = NewsResponse(title: title, date: date, url: urlString, increasePrice: increase)
                        dataSet.append(news)
                        dispatch.leave()
                    }
                }
            }
            dispatch.notify(queue: .main) {
                let sortedDataSet = dataSet.sorted { $0.date > $1.date }
                
                self.newsData = sortedDataSet
                self.newsCallBack?()
            }
            
        } catch {
            print("解析失敗：\(error)")
        }
    }
    
    private func getIncreasePrice(form text: String, completion: @escaping (String?) -> Void)  {
        guard let url = URL(string: "\(MainAPI.mainURL)/\(text)") else { return completion(nil)}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("❌ 請求失敗：\(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data,
                  let html = String(data: data, encoding: .utf8) else {
                completion(nil)
                return
            }
            
            if let html = String(data: data, encoding: .utf8) {
                
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let blocks: Elements = try doc.select("div.edit")
                    if let block = blocks.first {
                        let letter = try block.select("p").text()
                        if letter.contains("調漲"){
                            completion("調漲")
                        } else {
                            completion("調降")
                        }
                    }
                } catch {
                    print("解析失敗：\(error)")
                }
            }
        }
        task.resume()
    }
    /// Google places API for UIImage
    func fetchStationPhoto(id: String) {
        
        //let id = "ChIJs5ydyTiuEmsR0fRSlU0C7k0"
        placesClient.lookUpPlaceID(id) { (place, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let place = place else {
                print("❌ 無效的 Place ID")
                return
            }
            print("✅ 有效的 Place ID: \(place.name ?? "未知地點")")
            
            // 再去抓照片
            self.placesClient.lookUpPhotos(forPlaceID: id) { (photos, error) in
                if let error = error {
                    print("Error fetching photo metadata: \(error)")
                    return
                }
                guard let results = photos?.results, !results.isEmpty else {
                    print("No photos available for this place.")
                    return
                }
                
                let photoMetadata = results[0]
                let fetchPhotoRequest = GMSFetchPhotoRequest(photoMetadata: photoMetadata,
                                                             maxSize: CGSize(width: 4800, height: 4800))
                self.placesClient.fetchPhoto(with: fetchPhotoRequest) { (photoImage, error) in
                    guard let photoImage, error == nil else {
                        print("Handle photo error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    print("Display photo Image: \(photoImage)")
                    self.imageCallBack?(photoImage)
                }
            }
        }
    }
    
}


struct FeatureWithDistance: Codable {
    let feature: Feature
    let distance: Double
}

