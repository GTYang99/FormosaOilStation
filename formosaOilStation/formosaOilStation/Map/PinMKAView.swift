//
//  PinMKAnnoVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/5/7.
//

import UIKit
import MapKit
import SnapKit

class PinMKAView: MKAnnotationView {
    static let reuseID = "PinMKAnnoVC"
    
    private let calloutView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imgStation = UIImageView()
    
    var tappedCallOut: ((Feature) -> Void)?
    
    override var annotation: MKAnnotation? {
        willSet {
            if let pointAnnotation = newValue as? StagtionMKA {
                configure(for: pointAnnotation)
            }
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.canShowCallout = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
    }
    
    private func setupUI() {
        self.image = UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysTemplate)
        self.centerOffset = CGPoint(x: 0, y: -20)
        self.frame = CGRect(x: 0, y: 0, width: 6, height: 6)
        
        calloutView.backgroundColor = .white
        calloutView.layer.cornerRadius = 8
        calloutView.layer.masksToBounds = false
        calloutView.layer.shadowColor = UIColor.black.cgColor
        calloutView.layer.shadowOffset = CGSize(width: 0, height: 2)
        calloutView.layer.shadowRadius = 4
        calloutView.layer.shadowOpacity = 0.3
        calloutView.frame = CGRect(x: 0, y: 0, width: 240, height: 100) // 根據 calloutView 的大小調整
        drawTriangleView()
        
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .darkGray
        
        calloutView.addSubview(imgStation)
        calloutView.addSubview(titleLabel)
        calloutView.addSubview(subtitleLabel)
        addSubview(calloutView)
        
        // SnapKit Layout
        calloutView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(240)
            make.height.lessThanOrEqualTo(80)
        }
        imgStation.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(10)
            make.height.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(imgStation.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(imgStation.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(8)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(calloutTapped))
        tap.delegate = self
        calloutView.addGestureRecognizer(tap)
        calloutView.isUserInteractionEnabled = true
        calloutView.isHidden = true
    }
    
    private func configure(for annotation: StagtionMKA) {
        titleLabel.text = annotation.title
        subtitleLabel.text = annotation.subtitle
        imgStation.image = annotation.img
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        calloutView.isHidden = !selected

    }
    
    private func drawTriangleView() {
        let width: CGFloat = 20
        let height: CGFloat = 10

        let path = UIBezierPath()
        path.move(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 1)
        shapeLayer.shadowOpacity = 0.3
        shapeLayer.shadowRadius = 2

        let triangleView = UIView()
        triangleView.layer.insertSublayer(shapeLayer, at: 0)
        calloutView.addSubview(triangleView)

        triangleView.snp.makeConstraints { make in
            make.top.equalTo(calloutView.snp.bottom)
            make.centerX.equalTo(calloutView.snp.centerX)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }

        triangleView.layoutIfNeeded()
        shapeLayer.frame = triangleView.bounds
    }
    
    @objc private func calloutTapped() {
        print("tapped Callout")
        guard let annotation = self.annotation as? StagtionMKA, let feature = annotation.feature else { return }
        tappedCallOut?(feature)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 檢查是否點擊到 calloutView 或其子視圖
        if calloutView.frame.contains(point) {
            return true
        }
        return super.point(inside: point, with: event)
    }
}

extension PinMKAView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
