//
//  ExUILabel.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/8/5.
//

import Foundation
import UIKit

extension UILabel {
    func titleAndSubtitle(title: String, subtitle: String) {

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 45, weight: .semibold),
            .foregroundColor: UIColor.label
        ]

        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ]

        let titleAttributed = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleAttributed = NSAttributedString(string: subtitle, attributes: subtitleAttributes)

        titleAttributed.append(subtitleAttributed)

        self.attributedText = titleAttributed
        self.numberOfLines = 0
    }
}
