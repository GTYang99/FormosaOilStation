//
//  OilNearListVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/04/24.
//

import UIKit
import SnapKit

class MultiSelectItem: UIView {
    
    var data:[String]{
        get{
            var array = [String]()
            for btn in btnArray{
                if btn.isSelected == true{
                    array.append(btn.titleLabel?.text ?? "")
                }
            }
            return array
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray600
        return label
    }()
    
    var btnArray = [UIButton]()
    var item: [String]
    var btnScrollView = UIScrollView()
    
    var multiSelectedCallBack: (([String]) -> Void)?
    var multiSelectCellCancelCallBack: (([String]) -> Void)?
    
    init(item: [String], title: String? = " ") {
        self.item = item
        super.init(frame: .zero)
        titleLabel.text = title
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func elseBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        multiSelectedCallBack?(data)
    }
 
    func setup() {
        self.layoutIfNeeded()
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
            
        }
    }
}
