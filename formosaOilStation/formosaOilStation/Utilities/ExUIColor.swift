//
//  ExUIColor.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/24.
//

import UIKit

public extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) == 6 {
            var rgbValue: UInt64 = 0
            let scanner = Scanner(string: cString)
            if scanner.scanHexInt64(&rgbValue) {
                self.init(
                    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                    alpha: CGFloat(1.0)
                )
                return
            }
        }
        return nil
    }
    private static func PSColor(_ hexCode: PSColor) -> UIColor? {
        UIColor(hex: hexCode.rawValue)
    }
    
    static var gray600 = PSColor(.gray600)
    static var gray500 = PSColor(.gray500)
    static var gray400 = PSColor(.gray400)
    static var gray300 = PSColor(.gray300)
    static var gray200 = PSColor(.gray200)
    static var gray100 = PSColor(.gray100)
    static var gray000 = PSColor(.gray000)
    static var cBlue   = PSColor(.cBlue)
    static var cRed    = PSColor(.cRed)
    static var cGreen  = PSColor(.cGreen)
    static var fuel98  = PSColor(.fuel98)
    static var fuel95  = PSColor(.fuel95)
    static var fuel92  = PSColor(.fuel92)
    static var fuelDiesel  = PSColor(.fuelDiesel)
}

enum PSColor: String {
    case gray600    = "#2D3748"
    case gray500    = "#4A5568"
    case gray400    = "#718096"
    case gray300    = "#A0AEC0"
    case gray200    = "#CBD5E0"
    case gray100    = "#E2E8F0"
    case gray000    = "#F7FAFC"
    case cBlue      = "#63B3ED"
    case cRed       = "#FC8181"
    case cGreen     = "#68D391"
    case fuel98     = "#EF5B5B"
    case fuel95     = "#FFBA49"
    case fuel92     = "#5398BE"
    case fuelDiesel  = "#A4A9AD"
}

extension PSColor {
    var cgColor: CGColor? {
        return UIColor(hex: self.rawValue)?.cgColor
    }
    var uiColor: UIColor {
        return UIColor(hex: self.rawValue)!
    }
}
