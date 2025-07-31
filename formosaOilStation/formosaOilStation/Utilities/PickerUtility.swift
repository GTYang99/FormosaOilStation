//
//  PickerUtility.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/7/30.
//

import Foundation
import UIKit

class CustomPickerView: UIPickerView {
    
    var titles: [String] = []
    var subtitles: [String] = []
    var onSelectData: String?
    var number = 1
    var hours = Array(0...23).map { String(format: "%02d", $0) }
    var minutes = Array(0...59).map { String(format: "%02d", $0) }
    
    
    init(number: Int) {
        self.number = number
        super.init(frame: .zero)
        delegate = self
        dataSource = self
        if number == 2 {
            titles = hours
            subtitles = minutes
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UIPickerViewDelegate&DataSource

extension CustomPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return number
    }
    
    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if number == 1 {
            return titles.count
        } else {
            return component == 0 ? titles.count : subtitles.count
        }
    }
    
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if number == 1 {
            onSelectData = titles[row]
            return titles[row]
        } else {
            return component == 0 ? titles[row] : subtitles[row] 
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if number == 1, titles.count>0{
            onSelectData = titles[row]
        }
        if number == 2 {
            let hour = titles[pickerView.selectedRow(inComponent: 0)]
            let minute = subtitles[pickerView.selectedRow(inComponent: 1)]
            let timeString = "\(hour):\(minute)"
            
            onSelectData = timeString
        }
    }
}

enum PickerUtility {
    // Picker View
    static func createPicker(
        targetTF: UITextField,
        data: [Any],
        picker: CustomPickerView,
        target: Any?,
        onFinish: Selector?,
        onCancel: Selector?
    ) {
        // toolbar setup
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: onFinish)
        doneButton.tintColor = .link
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: target, action: onCancel)
        cancelButton.tintColor = .red
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        
        //picker.entityData = data
        targetTF.inputView = picker
        targetTF.inputAccessoryView = toolbar
        
        
        picker.titles = data as? [String] ?? [String]()
        picker.reloadAllComponents()
    }
    
    // Date Picker View
    static func createDatePicker(
        targetTF: UITextField,
        datePicker: UIDatePicker,
        target: Any?,
        onToday: Selector?,
        onFinish: Selector?
    ) {
        // set range
        datePicker.minimumDate = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 1).date
        datePicker.maximumDate = DateComponents(calendar: Calendar.current, year: 2099, month: 12, day: 31).date
        datePicker.tintColor = .darkGray
        datePicker.preferredDatePickerStyle = .inline
        
        // toolbar setup
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let todayButton = UIBarButtonItem(title: "今天", style: .plain, target: target, action: onToday)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: onFinish)
        toolbar.setItems([flexibleSpace, todayButton, doneButton], animated: true)
        
        // inputView
        targetTF.inputAccessoryView = toolbar
        targetTF.inputView = datePicker
        
        let mainWidth = UIScreen.main.bounds.width
        targetTF.inputView?.frame.size = CGSize(width: mainWidth, height: mainWidth)
        
        datePicker.datePickerMode = .date
    }
    
    // Picker View
    static func createTimePicker(
        targetTF: UITextField,
        picker: CustomPickerView,
        target: Any?,
        onFinish: Selector?,
        onCancel: Selector?
    ) {
        // toolbar setup
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
        toolbar.tintColor = .darkGray
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: onFinish)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: target, action: onCancel)
        doneButton.tintColor = .link
        cancelButton.tintColor = .red
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        
        //picker.entityData = data
        targetTF.inputView = picker
        targetTF.inputAccessoryView = toolbar
        
        picker.reloadAllComponents()
    }
}
