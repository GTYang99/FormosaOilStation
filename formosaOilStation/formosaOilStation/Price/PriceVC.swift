//
//  PriceVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/8/4.
//

import UIKit

class PriceVC: UIViewController {
    
    let lbPriceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.text = "牌價"
        return label
    }()
    
    lazy var view98: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fuel98
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.gray400?.cgColor
        let lb = UILabel()
        lb.text = "NTD/L"
        lb.font = UIFont.boldSystemFont(ofSize: 10)
        view.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
        }
        return view
    }()
    
    let img98: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fuel98")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let title98: UILabel = {
        let label = UILabel()
        label.titleAndSubtitle(title: "98", subtitle: "無鉛汽油")
        return label
    }()
    
    let subTitle98: UILabel = {
        let label = UILabel()
        label.text = "98 UNLEADED \nGASOLINE"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 3
        return label
    }()
    
    let price98: UILabel = {
        let label = UILabel()
        label.text = "99.9"
        label.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        return label
    }()
    
    lazy var view95: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fuel95
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.gray400?.cgColor
        let lb = UILabel()
        lb.text = "NTD/L"
        lb.font = UIFont.boldSystemFont(ofSize: 10)
        view.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
        }
        return view
    }()
    
    let img95: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fuel95")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let title95: UILabel = {
        let label = UILabel()
        label.titleAndSubtitle(title: "95", subtitle: "無鉛汽油")
        return label
    }()
    
    let subTitle95: UILabel = {
        let label = UILabel()
        label.text = "95 UNLEADED \nGASOLINE"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 3
        return label
    }()
    
    let price95: UILabel = {
        let label = UILabel()
        label.text = "99.9"
        label.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        return label
    }()
    
    lazy var view92: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fuel92
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.gray400?.cgColor
        let lb = UILabel()
        lb.text = "NTD/L"
        lb.font = UIFont.boldSystemFont(ofSize: 10)
        view.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
        }
        return view
    }()
    
    let img92: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fuel92")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let title92: UILabel = {
        let label = UILabel()
        label.titleAndSubtitle(title: "92", subtitle: "無鉛汽油")
        return label
    }()
    
    let subTitle92: UILabel = {
        let label = UILabel()
        label.text = "92 UNLEADED \nGASOLINE"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 3
        return label
    }()
    
    let price92: UILabel = {
        let label = UILabel()
        label.text = "99.9"
        label.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        return label
    }()
    
    lazy var viewDiesel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fuelDiesel
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.gray400?.cgColor
        let lb = UILabel()
        lb.text = "NTD/L"
        lb.font = UIFont.boldSystemFont(ofSize: 10)
        view.addSubview(lb)
        lb.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
        }
        return view
    }()
    
    let imgDiesel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fuelDiesel")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleDiesel: UILabel = {
        let label = UILabel()
        label.text = "超級\n柴油"
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let subTitleDiesel: UILabel = {
        let label = UILabel()
        label.text = "Diesel"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 3
        return label
    }()
    
    let priceDiesel: UILabel = {
        let label = UILabel()
        label.text = "99.9"
        label.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        return label
    }()
    
    let lbTimeRange: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "牌價生效時間:"
        return label
    }()
    
    let lbNewsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.text = "油價新聞"
        return label
    }()
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var tbNews = UITableView()
    
    var viewModel = FormosaViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initNews()
        viewModel.fetchMainHTML(.news)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchMainHTML(.fuelPrice)
    }
    
    func initUI() {
        tbNews.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        view.backgroundColor = .white
        
        view98.addSubview(img98)
        view95.addSubview(img95)
        view92.addSubview(img92)
        viewDiesel.addSubview(imgDiesel)
        view98.addSubview(title98)
        view95.addSubview(title95)
        view92.addSubview(title92)
        viewDiesel.addSubview(titleDiesel)
        view98.addSubview(subTitle98)
        view95.addSubview(subTitle95)
        view92.addSubview(subTitle92)
        viewDiesel.addSubview(subTitleDiesel)
        view98.addSubview(price98)
        view95.addSubview(price95)
        view92.addSubview(price92)
        viewDiesel.addSubview(priceDiesel)

        contentView.addSubview(lbPriceTitle)
        contentView.addSubview(view98)
        contentView.addSubview(view95)
        contentView.addSubview(view92)
        contentView.addSubview(viewDiesel)
        contentView.addSubview(lbTimeRange)
        contentView.addSubview(lbNewsTitle)
        contentView.addSubview(tbNews)
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
        // 這個是視口
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 這個是內容高度，推開在這
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        lbPriceTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        view98.snp.makeConstraints { make in
            make.top.equalTo(lbPriceTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        img98.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.height.width.greaterThanOrEqualTo(100)
        }
        title98.snp.makeConstraints { make in
            make.top.equalTo(img98.snp.top)
            make.leading.equalTo(img98.snp.trailing)
        }
        subTitle98.snp.makeConstraints { make in
            make.bottom.equalTo(img98.snp.bottom)
            make.leading.equalTo(img98.snp.trailing)
            make.bottom.equalToSuperview().inset(8)
        }
        price98.snp.makeConstraints { make in
            make.top.equalTo(img98.snp.top)
            make.leading.equalTo(title98.snp.trailing).offset(8)
        }
        view95.snp.makeConstraints { make in
            make.top.equalTo(view98.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        img95.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.height.width.greaterThanOrEqualTo(100)
        }
        title95.snp.makeConstraints { make in
            make.top.equalTo(img95.snp.top)
            make.leading.equalTo(img95.snp.trailing)
        }
        subTitle95.snp.makeConstraints { make in
            make.bottom.equalTo(img95.snp.bottom)
            make.leading.equalTo(img95.snp.trailing)
            make.bottom.equalToSuperview().inset(8)
        }
        price95.snp.makeConstraints { make in
            make.top.equalTo(img95.snp.top)
            make.leading.equalTo(title95.snp.trailing).offset(8)
        }
        view92.snp.makeConstraints { make in
            make.top.equalTo(view95.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        img92.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.height.width.greaterThanOrEqualTo(100)
        }
        title92.snp.makeConstraints { make in
            make.top.equalTo(img92.snp.top)
            make.leading.equalTo(img92.snp.trailing)
        }
        subTitle92.snp.makeConstraints { make in
            make.bottom.equalTo(img92.snp.bottom)
            make.leading.equalTo(img92.snp.trailing)
            make.bottom.equalToSuperview().inset(8)
        }
        price92.snp.makeConstraints { make in
            make.top.equalTo(img92.snp.top)
            make.leading.equalTo(title92.snp.trailing).offset(8)
        }
        viewDiesel.snp.makeConstraints { make in
            make.top.equalTo(view92.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        imgDiesel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.height.width.greaterThanOrEqualTo(100)
        }
        titleDiesel.snp.makeConstraints { make in
            make.top.equalTo(imgDiesel.snp.top)
            make.leading.equalTo(imgDiesel.snp.trailing)
        }
        subTitleDiesel.snp.makeConstraints { make in
            make.bottom.equalTo(imgDiesel.snp.bottom)
            make.leading.equalTo(imgDiesel.snp.trailing)
            make.bottom.equalToSuperview().inset(8)
        }
        priceDiesel.snp.makeConstraints { make in
            make.top.equalTo(imgDiesel.snp.top)
            make.leading.equalTo(titleDiesel.snp.trailing).offset(8)
        }
        lbTimeRange.snp.makeConstraints { make in
            make.top.equalTo(viewDiesel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        lbNewsTitle.snp.makeConstraints { make in
            make.top.equalTo(lbTimeRange.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tbNews.snp.makeConstraints { make in
            make.top.equalTo(lbNewsTitle.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    func initNews() {
        tbNews.delegate = self
        tbNews.dataSource = self
        tbNews.isScrollEnabled = false
        tbNews.separatorStyle = .none
        tbNews.estimatedRowHeight = 50
        
        viewModel.fuelPriceCallBack = { [weak self] results, date in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.lbTimeRange.text = "牌價生效時間:\(date)"
                for (key, value) in results {
                    switch key {
                    case .fuel92 :
                        self.price92.text = "\(value)"
                    case .fuel95 :
                        self.price95.text = "\(value)"
                    case .fuel98 :
                        self.price98.text = "\(value)"
                    case .fuel柴油 :
                        self.priceDiesel.text = "\(value)"
                    default:
                        break
                    }
                }
            }
        }
        viewModel.newsCallBack = { [weak self]  in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tbNews.reloadData()
                self.tbNews.snp.remakeConstraints { make in
                    make.top.equalTo(self.lbNewsTitle.snp.bottom).offset(8)
                    make.leading.trailing.equalToSuperview().inset(16)
                    make.height.equalTo(self.tbNews.contentSize.height)
                    make.bottom.equalToSuperview().inset(16)
                }
            }
        }
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


extension PriceVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier) as? NewsCell else {
            return UITableViewCell()
        }
        guard let data = viewModel.newsData?[indexPath.row]else {
            return cell
        }
        let date = DateManager.shared.dateToString(from: data.date)
        cell.configure(title: data.title, date: date, increase: data.increasePrice)
        
        /*
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "normal")
        let data = viewModel.newsData?[indexPath.row]
        cell.textLabel?.text = data?.title
        cell.detailTextLabel?.text = data?.date
        cell.accessoryType = .disclosureIndicator
        return cell
         */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.newsData?[indexPath.row]
        guard let url = data?.url else { return }
        let vc = NewsVC(shows: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
