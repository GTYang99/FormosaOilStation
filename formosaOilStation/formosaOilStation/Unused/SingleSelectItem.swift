//
//  OilNearListVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/04/24.
//

import UIKit
import SnapKit

class SingleSelectItem: UIView {
    
    var data:[String]{
        get{
            var array = [String]()
            if optionalYesBtn.isSelected == true && closetextField == false{
                array = [optionalYesBtn.titleLabel?.text ?? "",optionalYesTextField.text ?? ""]
            }else if optionalYesBtn.isSelected == true && closetextField == true{
                array = [optionalYesBtn.titleLabel?.text ?? ""]
            }else if optionalNoBtn.isSelected == true{
                array = [optionalNoBtn.titleLabel?.text ?? ""]
            }else{
                array = ["", ""]
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
    
    lazy var optionalYesBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 1
      
        btn.addTarget(self, action: #selector(singleSelectBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    var optionalYesTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "請輸入缺失原因*"
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftView = view
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.gray600?.cgColor
        tf.leftViewMode = .always
        tf.isEnabled = true
        tf.isSelected = true
        return tf
    }()
   
    
  
    lazy var optionalNoBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 0

        btn.isSelected = false
        btn.addTarget(self, action: #selector(singleSelectBtnTapped), for: .touchUpInside)
        return btn
    }()
    var closetextField = false
    var item: [String]
    var singleSelectedCallBack: (([String], String) -> Void)?
    var singleSelectCellCancelCallBack: (() -> Void)?
    
    init(item: [String] = [],chooseOneTitle: String = "是", chooseTwoTitle: String = "否", closetextField:Bool? = false, title:String) {
        self.item = item
        super.init(frame: .zero)
        titleLabel.text = title
       
        addSubview(titleLabel)
        addSubview(optionalYesBtn)
        addSubview(optionalNoBtn)
        addSubview(optionalYesTextField)
        self.closetextField = closetextField!
        if closetextField == true{
            optionalYesTextField.isHidden = true
        }
        setup()
    }
    
    @objc func singleSelectBtnTapped(_ sender: UIButton) {
        if sender.tag == 0{
            optionalNoBtn.isSelected = true
            optionalYesBtn.isSelected = false
            optionalYesTextField.isEnabled = false
        } else {
            optionalNoBtn.isSelected = false
            optionalYesBtn.isSelected = true
            optionalYesTextField.isEnabled = true
        }
        checkSelect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setup() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
        }
        optionalYesBtn.snp.makeConstraints { make in
            if optionalYesTextField.isHidden{
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }else{
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
            }
            make.width.equalTo(optionalYesBtn.intrinsicContentSize.width)
            make.left.equalTo(self.snp.left)
        }
        optionalYesTextField.snp.makeConstraints { make in
            make.centerY.equalTo(optionalYesBtn)
            make.left.equalTo(optionalYesBtn.snp.right).offset(10)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(44)
        }
        
        optionalNoBtn.snp.makeConstraints { make in
            make.top.equalTo(optionalYesBtn.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    func checkSelect() {
    }
}

extension SingleSelectItem: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        checkSelect()
    }
}
