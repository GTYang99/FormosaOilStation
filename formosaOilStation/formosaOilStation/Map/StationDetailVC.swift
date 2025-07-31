//
//  StationDetailVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/7/28.
//

import UIKit

class StationDetailVC: UIViewController {
    
    var data: Feature? {
        didSet {
            self.loadViewIfNeeded()
        }
    }
    
    var viewModel = FormosaViewModel()
    
    let topImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "佔位圖") // 模擬圖
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let stationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "佔位圖")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let starLabel: UIView = {
        let view = UIView()
        let label = UILabel()
        let starLabel = UILabel()
        let number: Int = 1
        view.addSubview(label)
        view.addSubview(starLabel)
        switch number {
        case 1:
            starLabel.text = "⭐☆☆☆☆"
        case 2:
            starLabel.text = "⭐⭐☆☆☆"
        case 3:
            starLabel.text = "⭐⭐⭐☆☆"
        case 4:
            starLabel.text = "⭐⭐⭐⭐☆"
        case 5:
            starLabel.text = "⭐⭐⭐⭐⭐"
        default:
            starLabel.text = "⭐☆☆☆☆"
        }
        label.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let openInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let buttonStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var saveBtn = makeCircleButton(image: "square.and.arrow.down.on.square", title: "Save")
    lazy var shareBtn = makeCircleButton(image: "square.and.arrow.up", title: "Share")
    lazy var navigateBtn = makeCircleButton(image: "arrow.turn.up.right", title: "Navigate")

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func configure(data: Feature) {
        self.data = data
    }
    
    func initUI() {
        guard let data = self.data
            , let title = data.properties?.站名 else { return }
        stationTitleLabel.text = title
        addressLabel.text = data.properties?.地址
        let far = viewModel.distanceString(data)
        if let distance = far?.distance {
            switch distance {
            case 0...1000:
                let text = "\(String(format: "%.1f", distance / 1000)) km"
                distanceLabel.text = text
            case ...0 :
                let text = "\(String(format: "%.2f", distance)) m"
                distanceLabel.text = text
            default:
                let text = "\(String(format: "%.1f", distance / 1000)) km"
                distanceLabel.text = text
            }
            //distanceLabel.text = "\(String(distance?.distance ?? 0.0)) km"
        }
        openInfoLabel.text = data.properties?.營業時間
     
        logoImageView.image = MainManager.shared.transICON(title: title)
        buttonStack.addArrangedSubview(saveBtn)
        buttonStack.addArrangedSubview(shareBtn)
        buttonStack.addArrangedSubview(navigateBtn)
        
        view.addSubview(topImageView)
        view.addSubview(stationTitleLabel)
        view.addSubview(logoImageView)
        view.addSubview(addressLabel)
        view.addSubview(distanceLabel)
        view.addSubview(openInfoLabel)
        view.addSubview(buttonStack)
        view.backgroundColor = .white
        
        topImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(stationTitleLabel.snp.top)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(80)
        }
        
        stationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topImageView.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(logoImageView.snp.leading).offset(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(stationTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(stationTitleLabel.snp.leading)
            make.trailing.equalTo(stationTitleLabel.snp.trailing)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
            make.leading.equalTo(stationTitleLabel.snp.leading)
            make.trailing.equalTo(stationTitleLabel.snp.trailing)
        }
        
        openInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(10)
            make.leading.equalTo(stationTitleLabel.snp.leading)
            make.trailing.equalTo(stationTitleLabel.snp.trailing)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(openInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func makeCircleButton(image: String, title: String) -> UIView {
        let imageView = UIImageView(image: UIImage(systemName: image))
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        
        let circle = UIView()
        circle.addSubview(imageView)
        circle.layer.cornerRadius = 30
        circle.backgroundColor = .clear
        circle.layer.borderColor = UIColor.darkGray.cgColor
        circle.layer.borderWidth = 1.5
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        
        let container = UIView()
        container.addSubview(circle)
        container.addSubview(label)
        container.backgroundColor = .clear
         
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.center.equalToSuperview()
        }
        circle.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(circle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        container.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        return container
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
