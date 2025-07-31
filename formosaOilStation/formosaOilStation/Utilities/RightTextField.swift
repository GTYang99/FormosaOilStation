//
//  RightTextField.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/7/30.
//

import Foundation
import UIKit

class RightViewTextfield: UITextField {
    var rightViewWidth: CGFloat = 20
    var padding: CGFloat = 12

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            x: bounds.width - rightViewWidth - padding,
            y: padding,
            width: rightViewWidth,
            height: rightViewWidth
        )
    }

    func addRightView(_ view: UIView,
                      width: CGFloat = 20,
                      padding: CGFloat = 12,
                      mode: UITextField.ViewMode = .always) {
        rightViewWidth = width
        self.padding = padding
        rightView = view
        rightViewMode = mode
    }
}
