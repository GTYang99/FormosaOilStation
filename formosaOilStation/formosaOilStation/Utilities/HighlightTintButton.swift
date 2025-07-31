//
//  ExOverRide.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/24.
//

import UIKit

class HighlightTintButton: UIButton {
    
    var customRoundedCorners: UIRectCorner?
    var customCornerRadius: CGFloat = 0
    var btnSelectCallBack: ((Bool) -> Void)?
    
    override var isHighlighted: Bool {
        didSet {
            tintColor = isHighlighted ? .darkGray: .black
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.gray100 : .clear
            btnSelectCallBack?(isSelected)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let corners = customRoundedCorners {
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: customCornerRadius, height: customCornerRadius)
            )
            path.lineWidth = 1
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.customRoundedCorners = corners
        self.customCornerRadius = radius
        setNeedsLayout()
    }
}
