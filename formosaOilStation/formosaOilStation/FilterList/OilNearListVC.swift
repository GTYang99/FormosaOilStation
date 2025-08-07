//
//  OilNearListVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/24.
//

import UIKit
import SnapKit

class OilNearListVC: UIViewController {
    
    //MARK: UI init
    let btnDismissView: UIButton = {
        let btn = UIButton()
        btn.setTitle("重新設置", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.darkGray, for: .highlighted)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(tapdBtnReset), for: .touchUpInside)
        return btn
    }()

    let btnReset: UIButton = {
        let btn = HighlightTintButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let img = UIImage(systemName: "xmark.circle", withConfiguration: config)
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(tapBtnDismissView), for: .touchUpInside)
        return btn
    }()
    
    let titleView: UILabel = {
        let label = UILabel()
        label.text = "加油站篩選"
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        return label
    }()
    
    let titleBrand: UILabel = {
        let label = UILabel()
        label.text = "廠牌"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let titleFuelType: UILabel = {
        let label = UILabel()
        label.text = "油種"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let btnBrand: [HighlightTintButton] = {
        var btns = [HighlightTintButton]()
        let titles: [String] = ["台亞石油", "全國加油站", "統一加油站", "福懋加油站", "山隆加油站"]
        for title in titles {
            let btn = HighlightTintButton()
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            btn.layer.cornerRadius = 8
            btn.layer.borderWidth = 1
            btn.layer.borderColor = PSColor.gray200.cgColor
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.darkGray, for: .selected)
            btn.addTarget(self, action: #selector(tapBrandButton(_:)), for: .touchUpInside)
            btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
            btns.append(btn)
        }
        return btns
    }()
    
    let btnFuelTypes: [HighlightTintButton] = {
        var btns = [HighlightTintButton]()
        let titles: [String] = ["98無鉛", "95Plus無鉛", "92無鉛", "超級柴油"]
        for title in titles {
            let btn = HighlightTintButton()
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            btn.layer.cornerRadius = 8
            btn.layer.borderWidth = 1
            btn.layer.borderColor = PSColor.gray200.cgColor
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.darkGray, for: .selected)
            btn.addTarget(self, action: #selector(tapFuelTypeButton(_:)), for: .touchUpInside)
            btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
            btns.append(btn)
        }
        return btns
    }()
    
    let scvBrand: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let scvFuelType: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let stBtnBrand: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let stBtnFuelType: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let btnTimes: [HighlightTintButton] = {
        var btns = [HighlightTintButton]()
        let titles: [String] = ["營業中", "一小時內抵達", "自訂時間"]
        for (index, title) in titles.enumerated() {
            let btn = HighlightTintButton()
            if index == 0 {
                btn.roundCorners(UIRectCorner([.topLeft, .bottomLeft]), radius: 10)
            }
            if index == 2 {
                btn.roundCorners(UIRectCorner([.topRight, .bottomRight]), radius: 10)
            }
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.darkGray, for: .selected)
            btn.addTarget(self, action: #selector(tapTimeButton(_:)), for: .touchUpInside)
            btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
            btns.append(btn)
        }
        return btns
    }()
    
    let stBtnTime: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 10
        stackView.layer.borderColor = PSColor.gray200.cgColor
        return stackView
    }()

    var timePicker = CustomPickerView(number: 2)
    private var activeTimeTF: RightViewTextfield?
    
    let startTF: RightViewTextfield = {
        let tf = RightViewTextfield()
        tf.placeholder = "開始時間"
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftView = view
        tf.leftViewMode = .always
        tf.layer.borderWidth = 1
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.gray100?.cgColor
        tf.layer.cornerRadius = 5
        lazy var chevronImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "clock")
            imageView.tintColor = .gray
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        tf.addRightView(chevronImageView, width: 20, padding: 10)
        tf.addTarget(self, action: #selector (showTimePicker), for: .editingDidBegin)
        return tf
    }()
    
    let endTF: RightViewTextfield = {
        let tf = RightViewTextfield()
        tf.placeholder = "結束時間"
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftView = view
        tf.leftViewMode = .always
        tf.layer.borderWidth = 1
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.gray100?.cgColor
        tf.layer.cornerRadius = 5
        lazy var chevronImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "clock")
            imageView.tintColor = .gray
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        tf.addRightView(chevronImageView, width: 20, padding: 10)
        tf.addTarget(self, action: #selector (showTimePicker), for: .editingDidBegin)
        return tf
    }()

    let titleHours: UILabel = {
        let label = UILabel()
        label.text = "時間"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let titleDistance: UILabel = {
        let label = UILabel()
        label.text = "距離"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let sliderbarDistance: UISlider = {
        let slider = UISlider()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let gray500 = PSColor.gray500.uiColor
        let img = UIImage(systemName: "car.side.arrowtriangle.down.fill", withConfiguration: config)?
            .withTintColor(gray500, renderingMode: .alwaysOriginal)
        let flippedImg = img?.flippedHorizontally()
        let movinImg = flippedImg?.imageByOffsetting(yOffset: -30)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.tintColor = .gray500
        slider.isContinuous = true
        slider.setThumbImage(movinImg, for: .normal)
        slider.addTarget(self, action: #selector(sliderbarDistanceValueChanged), for: .valueChanged)
        return slider
    }()
    
    let lblDistanceValue: UILabel = {
        let lb = UILabel()
        lb.text = "0km"
        lb.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lb.textColor = .gray500
        return lb
    }()
    
    let lbMinDistance: UILabel = {
        let lb = UILabel()
        lb.text = "0 km"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = .gray400
        return lb
    }()
    
    let lbMaxDistance: UILabel = {
        let lb = UILabel()
        lb.text = "10 km"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = .gray400
        return lb
    }()
    
    let searchBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("確認", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .gray600
        return btn
    }()
    
    //MARK: Data
    var filterBrands: [加油站廠牌] = []
    var filterFuelType: [String] = []
    var filterTime: [Date?] = [nil, nil]
    var viewModel: FormosaViewModel?
    
    init(viewModel: FormosaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        view.addSubview(btnDismissView)
        view.addSubview(titleView)
        view.addSubview(btnReset)
        view.addSubview(titleBrand)
        view.addSubview(scvBrand)
        scvBrand.addSubview(stBtnBrand)
        view.addSubview(titleFuelType)
        view.addSubview(scvFuelType)
        scvFuelType.addSubview(stBtnFuelType)
        view.addSubview(stBtnTime)
        view.addSubview(startTF)
        view.addSubview(endTF)
        
        view.addSubview(titleHours)
        view.addSubview(titleDistance)
        view.addSubview(lblDistanceValue)
        view.addSubview(sliderbarDistance)
        view.addSubview(lbMinDistance)
        view.addSubview(lbMaxDistance)
        view.addSubview(searchBtn)
        view.backgroundColor = .white
        
        btnDismissView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        btnReset.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
        }
        
        titleBrand.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleView.snp.bottom).offset(50)
        }
        
        scvBrand.snp.makeConstraints { make in
            make.top.equalTo(titleBrand.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        for button in btnBrand {
            stBtnBrand.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo(120)
            }
        }
        
        stBtnBrand.snp.makeConstraints { make in
            make.edges.equalTo(scvBrand.contentLayoutGuide)
            make.height.equalTo(60)
        }
        
        titleFuelType.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(stBtnBrand.snp.bottom).offset(32)
        }
        
        scvFuelType.snp.makeConstraints { make in
            make.top.equalTo(titleFuelType.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        
        for button in btnFuelTypes {
            stBtnFuelType.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo(120)
            }
        }
        
        stBtnFuelType.snp.makeConstraints { make in
            make.edges.equalTo(scvFuelType.contentLayoutGuide)
            make.height.equalTo(60)
        }
        
        titleHours.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(btnFuelTypes[0].snp.bottom).offset(32)
        }
        
        for button in btnTimes {
            stBtnTime.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalToSuperview().dividedBy(3)
            }
        }
        
        stBtnTime.snp.makeConstraints { make in
            make.top.equalTo(titleHours.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        titleDistance.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(stBtnTime.snp.bottom).offset(32)
        }
        
        lblDistanceValue.snp.makeConstraints { make in
            make.top.equalTo(titleDistance.snp.top)
            make.centerX.equalToSuperview()
        }
        
        sliderbarDistance.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(titleDistance.snp.bottom).offset(16)
        }
        
        lbMinDistance.snp.makeConstraints { make in
            make.centerX.equalTo(sliderbarDistance.snp.leading)
            make.top.equalTo(sliderbarDistance.snp.bottom).offset(8)
        }
        
        lbMaxDistance.snp.makeConstraints { make in
            make.centerX.equalTo(sliderbarDistance.snp.trailing)
            make.top.equalTo(sliderbarDistance.snp.bottom).offset(8)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
            make.leading.trailing.equalTo(titleDistance).inset(16)
            make.height.equalTo(60)
        }
        
        searchBtn.addTarget(self, action: #selector(didTapSearchBtn), for: .touchUpInside)
    }
    
    @objc func tapdBtnReset() {
        for btn in btnTimes {
            btn.isSelected = false
        }
        for btn in btnFuelTypes {
            btn.isSelected = false
        }
        for btn in btnBrand {
            btn.isSelected = false
        }
        filterBrands.removeAll()
        filterFuelType.removeAll()
        startTF.text = ""
        endTF.text = ""
        filterTime[0] = nil
        filterTime[1] = nil
        sliderbarDistance.value = 0
        timeSelector(open: false)
    }
    
    @objc func tapBtnDismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapBrandButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender {
        case btnBrand[0]:
            sender.isSelected ? (filterBrands.append(加油站廠牌.台亞)): (filterBrands.removeAll(where: { $0 == .台亞}))
        case btnBrand[1]:
            sender.isSelected ? (filterBrands.append(加油站廠牌.全國)): (filterBrands.removeAll(where: { $0 == .全國}))
        case btnBrand[2]:
            sender.isSelected ? (filterBrands.append(加油站廠牌.統一)): (filterBrands.removeAll(where: { $0 == .統一}))
        case btnBrand[3]:
            sender.isSelected ? (filterBrands.append(加油站廠牌.福懋)): (filterBrands.removeAll(where: { $0 == .福懋}))
        case btnBrand[4]:
            sender.isSelected ? (filterBrands.append(加油站廠牌.山隆)): (filterBrands.removeAll(where: { $0 == .山隆}))
        default: break
        }
    }
    
    @objc func tapFuelTypeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender {
        case btnFuelTypes[0]:
            sender.isSelected ? (filterFuelType.append("98")): (filterFuelType.removeAll{ $0.contains("98") })
        case btnFuelTypes[1]:
            sender.isSelected ? (filterFuelType.append("95")): (filterFuelType.removeAll{ $0.contains("95") })
        case btnFuelTypes[2]:
            sender.isSelected ? (filterFuelType.append("92")): (filterFuelType.removeAll{ $0.contains("92") })
        case btnFuelTypes[3]:
            sender.isSelected ? (filterFuelType.append("柴油")): (filterFuelType.removeAll{ $0.contains("柴油") })
        default: break
        }
    }
    
    @objc func tapTimeButton(_ sender: UIButton) {
        let now = Date()
        //let time = DateManager.shared.timeToString(time: now)
        let nowPlusOne = Calendar.current.date(byAdding: .hour, value: 1, to: now)!
        let oneHourLater = DateManager.shared.timeToString(time: nowPlusOne)
        
        for button in btnTimes {
            if button == sender, button.isSelected {
                button.isSelected = false
            } else {
                button.isSelected = (button == sender)
            }
        }
        filterTime = [nil, nil]
        switch sender {
        case btnTimes[0]:
            filterTime[1] = sender.isSelected ? now : Date()
            timeSelector(open: false)
        case btnTimes[1]:
            timeSelector(open: false)
            if sender.isSelected {
                filterTime[0] = now
                filterTime[1] = nowPlusOne
            } else {
                filterTime[0] = nil
                filterTime[1] = nil
            }
        case btnTimes[2]:
            sender.isSelected ? timeSelector(open: true): timeSelector(open: false)
        default: break
        }
        print("\(filterTime)")
    }
    
    @objc func sliderbarDistanceValueChanged(_ slider: UISlider) {
        let value: Float = slider.value / 10
        lblDistanceValue.text = String(format: "%.1fkm", value)
        viewModel?.filterDistance = Double(value)
    }
    
    func timeSelector(open: Bool) {
        if open {
            startTF.isHidden = false
            endTF.isHidden = false
            startTF.snp.makeConstraints { make in
                make.top.equalTo(stBtnTime.snp.bottom).offset(32)
                make.height.equalTo(40)
                make.leading.equalToSuperview().inset(16)
                make.width.equalToSuperview().dividedBy(2).inset(16)
            }
            endTF.snp.makeConstraints { make in
                make.top.equalTo(startTF.snp.top)
                make.height.equalTo(40)
                make.trailing.equalToSuperview().inset(16)
                make.width.equalToSuperview().dividedBy(2).inset(16)
            }
            titleDistance.snp.remakeConstraints { make in
                make.top.equalTo(startTF.snp.bottom).offset(32)
                make.leading.equalToSuperview().inset(16)
            }
        } else {
            startTF.isHidden = true
            endTF.isHidden = true
            titleDistance.snp.remakeConstraints { make in
                make.top.equalTo(stBtnTime.snp.bottom).offset(32)
                make.leading.equalToSuperview().inset(16)
            }
        }
    }
    
    @objc private func showTimePicker(_ sender: RightViewTextfield){
        activeTimeTF = sender
        PickerUtility.createTimePicker(
            targetTF: sender,
            picker: timePicker,
            target: self,
            onFinish: #selector(finish),
            onCancel: #selector(cancel))
    }
    
    @objc private func finish(){
        guard let tf = activeTimeTF else { return }
        tf.resignFirstResponder()
        
        if tf == startTF {
            guard let text = timePicker.onSelectData else { return }
            startTF.text = text
            let time = DateManager.shared.stringToTime(from: text)
            filterTime[0] = time
        }
        if tf == endTF {
            guard let text = timePicker.onSelectData else { return }
            endTF.text = text
            let time = DateManager.shared.stringToTime(from: text)
            filterTime[1] = time
        }
        activeTimeTF = nil
        print("\(filterTime)")
    }
    
    @objc private func cancel(){
        timePicker.resignFirstResponder()
    }
    
    @objc private func didTapSearchBtn(){
        viewModel?.filterCondition(brands: filterBrands, fuelType: filterFuelType, time: filterTime, distance: viewModel?.filterDistance ?? 10.0)
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
