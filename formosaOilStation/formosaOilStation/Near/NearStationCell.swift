//
//  NearStationCell.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/25.
//

import UIKit
import SnapKit
import MapKit

class NearStationCell: UITableViewCell {
    
    var onSelectStation: ((CLLocationCoordinate2D) -> Void)?
    var onFavoriteCallBack: ((Bool) -> Void)?
    
    let img = UIImageView()
    let title : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    let location: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
    }()
    let openTime: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
    }()
    let distance : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 32)
        lb.textAlignment = .right
        return lb
    }()
    
    let btnDirection: UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let img = UIImage(systemName: "arrowshape.turn.up.right", withConfiguration: config)
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(tapNavBtn), for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    let btnDirectionBackground: UIView = {
        let bg = UIView()
        bg.backgroundColor = .gray100
        bg.layer.cornerRadius = 15
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.shadowOpacity = 0.2
        bg.layer.shadowOffset = CGSize(width: 0, height: 2)
        bg.layer.shadowRadius = 15
        return bg
    }()
    
    let btnFavorite: UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let img = UIImage(systemName: "star.fill", withConfiguration: config)
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(tapFavoriteBtn), for: .touchUpInside)
        return btn
    }()
    
    let btnFavoriteBackground: UIView = {
        let bg = UIView()
        bg.backgroundColor = .gray100
        bg.layer.cornerRadius = 15
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.shadowOpacity = 0.2
        bg.layer.shadowOffset = CGSize(width: 0, height: 2)
        bg.layer.shadowRadius = 10
        return bg
    }()
    
    let backgroundLayer: UIView = {
        let view = UIView()
        return view
    }()
    
    var  data: Feature?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with data: Feature) {
        self.data = data
        guard let 站名 = data.properties?.站名
              , let 地址 = data.properties?.地址
              , let 營業時間 = data.properties?.營業時間 else { return }
        
        title.text = 站名
        location.text = 地址
        openTime.text = 營業時間
        img.image = MainManager.shared.transICON(title: 站名)
    }
    
    
    func setupCellUI () {
        contentView.addSubview(backgroundLayer)
        backgroundLayer.addSubview(img)
        backgroundLayer.addSubview(title)
        backgroundLayer.addSubview(location)
        backgroundLayer.addSubview(openTime)
        backgroundLayer.addSubview(distance)
        backgroundLayer.addSubview(btnFavoriteBackground)
        backgroundLayer.addSubview(btnDirectionBackground)
        btnFavoriteBackground.addSubview(btnFavorite)
        btnDirectionBackground.addSubview(btnDirection)
        
        backgroundLayer.layer.borderColor = PSColor.gray100.cgColor
        backgroundLayer.layer.cornerRadius = 10
        backgroundLayer.layer.borderWidth = 1
        
        backgroundLayer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
                
        }
        img.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        distance.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(img.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        location.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.equalTo(img.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        openTime.snp.makeConstraints { make in
            make.top.equalTo(location.snp.bottom).offset(5)
            make.leading.equalTo(img.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        btnDirectionBackground.snp.makeConstraints { make in
            make.top.equalTo(openTime.snp.bottom).offset(10)
            make.leading.equalTo(img.snp.trailing).offset(20)
            make.width.height.equalTo(30)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        btnDirection.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        btnFavoriteBackground.snp.makeConstraints { make in
            make.centerY.equalTo(btnDirectionBackground)
            make.leading.equalTo(btnDirectionBackground.snp.trailing).offset(10)
            make.width.height.equalTo(30)
        }
        
        btnFavorite.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func tapNavBtn(_ sender: UIButton) {
        guard let coordinate = data?.coordinate else { return }
        
        let coordinate2D: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
            
        onSelectStation?(coordinate)
    }
    @objc func tapFavoriteBtn(_ sender: UIButton) {
        if let data = data {
            onFavoriteCallBack?(MainManager.shared.saveFavoriteStations(data))
        }
    }
}
