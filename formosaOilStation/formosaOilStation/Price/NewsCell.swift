//
//  NewsCell.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/8/8.
//

import UIKit
import SnapKit

class NewsCell: UITableViewCell {
    
    static let reuseIdentifier = "newsCell"
    
    private let readPoint: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "circle.fill")
        view.tintColor = UIColor.green
        return view
    }()
    
    private let increaseIcon: UIImageView = {
        let view = UIImageView()
//        view.image = UIImage(systemName: "arrowshape.up")
//        view.image = UIImage(named: "increase")
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor.green
        return view
    }()
    
    private let viewLeft: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 6
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let lbDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let lbTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String, date: String, increase: Bool){
        self.lbTitle.text = title
        self.lbDate.text = date
        increaseIcon.image = increase ? UIImage(named: "increase") : UIImage(named: "decrease")
        increaseIcon.tintColor = increase ? .red: .green
    }
    
    func setupUI() {
        
        //viewLeft.addSubview(readPoint)
        viewLeft.addSubview(lbDate)
        contentView.addSubview(increaseIcon)
        contentView.addSubview(lbTitle)
        contentView.addSubview(viewLeft)
            
        viewLeft.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(2.5)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        lbDate.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        /*
        readPoint.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(5)
            make.height.width.equalTo(5)
        }
        */
        increaseIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.height.width.greaterThanOrEqualTo(40)
        }
        
        lbTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(viewLeft.snp.trailing).offset(8)
            make.trailing.equalTo(increaseIcon.snp.leading)
            make.bottom.equalToSuperview().inset(8)
        }
        
    }

}
