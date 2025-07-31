//
//  ExUIImage.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/25.
//

import UIKit
import Foundation

extension UIImage {
    func flippedHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return nil }
        
        context.translateBy(x: size.width, y: size.height)
        context.scaleBy(x: -1.0, y: -1.0)
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedImage
    }
    
    func imageByOffsetting(yOffset: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width, height: size.height + abs(yOffset))
        let origin = CGPoint(x: 0, y: yOffset > 0 ? yOffset : 0)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(at: origin)
        let shiftedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return shiftedImage
    }
}
