//
//  StationP.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/17.
//

import Foundation
import MapKit

// MARK: - Test
struct OilStations: Codable {
    let type: String?
    let features: [Feature]?
}

// MARK: - Feature
struct Feature: Codable {
    let type: FeatureType?
    let geometry: Geometry?
    let properties: Properties?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType?
    let coordinates: [Double]?
}

enum GeometryType: String, Codable {
    case point = "Point"
}

// MARK: - Properties
struct Properties: Codable {
    let 城市, 站名, 地址, 電話: String?
    let 營業時間: String?
    let 類型: [類型]?
    let the98無鉛, the95Plus無鉛, the92無鉛, 超級柴油: Bool?
    let fuel98, fuel95, fuel92: Bool?
    let 洗車服務, 打氣機, 車用尿素水, 台塑石油Pay: Bool?
    let 自助加油設備 ,不斷電加油服務: Bool?
    let 帝雉卡儲值, 國旅卡, 悠遊卡, 一卡通: Bool?
    let 愛金卡, pi拍錢包, 街口支付, linePay: Bool?
    let 悠遊付: Bool?
    let 台塑石油APP, 台塑聯名卡, 台塑商務卡, 國民旅遊卡, Taxi卡: Bool?

    enum CodingKeys: String, CodingKey {
        case 城市, 站名, 地址, 電話, 營業時間, 類型
        case the98無鉛, fuel98 = "98無鉛"
        case the95Plus無鉛, fuel95 = "95Plus無鉛"
        case the92無鉛, fuel92 = "92無鉛"
        case 超級柴油, 洗車服務, 打氣機, 車用尿素水
        case 自助加油設備 ,不斷電加油服務
        case 台塑石油Pay = "台塑石油PAY"
        case 帝雉卡儲值, 國旅卡, 悠遊卡, 一卡通, 愛金卡
        case pi拍錢包 = "Pi拍錢包"
        case 街口支付
        case linePay = "LINE Pay"
        case 悠遊付
        case 台塑石油APP, 台塑聯名卡, 台塑商務卡, 國民旅遊卡, Taxi卡
    }
}

enum 類型: String, Codable {
    case 人工加油站據點 = "人工加油站據點"
    case 帝雉儲值卡據點 = "帝雉儲值卡據點"
    case 自助加油站據點 = "自助加油站據點"
    case 車用尿素水據點 = "車用尿素水據點"
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}

typealias Stations = [OilStations]

extension Feature {
    var coordinate: CLLocationCoordinate2D? {
        guard let geometry = self.geometry else { return nil }
        return CLLocationCoordinate2D(latitude: geometry.coordinates?[1] ?? 0, longitude: geometry.coordinates?[0] ?? 0)
    }
    
}

enum 加油站廠牌: String, Codable {
    case 台亞 = "台亞"
    case 福懋 = "福懋"
    case 統一 = "統一"
    case 全國 = "全國"
    case 山隆 = "山隆"
    
    func isSatisfied(by station: Properties) -> Bool {
        switch self {
        case .台亞:
            return station.站名?.contains("台亞") == true
        case .福懋:
            return station.站名?.contains("福懋") == true
        case .統一:
            return station.站名?.contains("統一") == true
        case .全國:
            return station.站名?.contains("全國") == true
        case .山隆:
            return station.站名?.contains("山隆") == true
        }
    }
}

enum 油種: String, Codable {
    case fuel98 = "98"
    case fuel95 = "95"
    case fuel92 = "92"
    case fuel柴油 = "柴油"
}

enum MainAPI {
    private static let main = "https://www.fpcc.com.tw"

    // get desire Link
    static var mainURL: String {
        main
    }
}

struct ConnectAPI {
    enum ParserURL {
        case fuelPrice
        case news
        
        var url: URL {
            switch self {
            case .fuelPrice:
                return URL(string: "\(MainAPI.mainURL)/tw/price")!
            case .news:
                return URL(string: "\(MainAPI.mainURL)/tw/news/articles")!
            }
        }
    }
}


struct NewsResponse: Codable {
    let title: String
    let date: Date
    let url: String
    let increasePrice: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, date, url, increasePrice
    }
}
