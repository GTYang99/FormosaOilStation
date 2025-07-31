//
//  PointAnnotation.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/5/7.
//

import UIKit
import MapKit

class StagtionMKA: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var title: String? {
        station?.站名
    }
    var subtitle: String? {
        station?.電話
    }
    var img: UIImage?
    
    var station: Properties?
    var feature: Feature?

    init(feature: Feature) {
        self.feature = feature
        super.init()
        configuare(feature)
    }
    
    func configuare(_ feature: Feature) {
        guard let coordinate = feature.coordinate
            , let properties = feature.properties
            , let title = properties.站名 else { return }
        self.coordinate = coordinate
        self.station = properties
        img = MainManager.shared.transICON(title: title)
    }
}
