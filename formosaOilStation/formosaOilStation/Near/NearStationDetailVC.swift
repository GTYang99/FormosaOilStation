//
//  NearStationDetailVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/30.
//

import UIKit
import SnapKit
import MapKit

class NearStationDetailVC: UIViewController {
    
    var tbInfo = UITableView()
    var dataInfo: Feature? {
        didSet{
            tbInfo.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
        tbInfo.delegate = self
        tbInfo.dataSource = self
        view.backgroundColor = .white
        //tbInfo.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(tbInfo)
        tbInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
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

extension NearStationDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dataInfo != nil else { return 0 }
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataInfo = dataInfo
                ,let properties = dataInfo.properties else { return UITableViewCell() }
        
        let cell = UITableViewCell(style: .value2, reuseIdentifier: nil)
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "站名"
            cell.detailTextLabel?.text = properties.站名
        case 1:
            cell.textLabel?.text = "地址"
            cell.detailTextLabel?.text = properties.地址
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.textLabel?.text = "電話"
            cell.detailTextLabel?.text = properties.電話
            cell.accessoryType = .disclosureIndicator
        case 3:
            cell.textLabel?.text = "營業時間"
            cell.detailTextLabel?.text = properties.營業時間
        case 4:
            cell.textLabel?.text = "油品類型"
            let oilTypes: [String] = [
                properties.the92無鉛 == true ? "92" : nil,
                properties.the95Plus無鉛 == true ? "95Plus" : nil,
                properties.the98無鉛 == true ? "98" : nil,
                properties.fuel92 == true ? "92" : nil,
                properties.fuel95 == true ? "95Plus" : nil,
                properties.fuel98 == true ? "98" : nil,
                properties.超級柴油 == true ? "超級柴油" : nil
            ].compactMap { $0 }
            
            cell.detailTextLabel?.text = oilTypes.joined(separator: "、")
        case 5:
                cell.textLabel?.text = "其他服務"
                let service: [String] = [
                    properties.打氣機 == true ? "打氣機" : nil,
                    properties.洗車服務 == true ? "洗車服務" : nil,
                    properties.車用尿素水 == true ? "車用尿素水" : nil,
                    properties.自助加油設備 == true ? "自助加油設備" : nil,
                    properties.不斷電加油服務 == true ? "不斷電加油服務" : nil
                ].compactMap { $0 }
            cell.detailTextLabel?.text = service.joined(separator: "、")
            cell.detailTextLabel?.numberOfLines = 0
        case 6:
                cell.textLabel?.text = "支付方式"
                let pay: [String] = [
                    properties.linePay == true ? "Line Pay" : nil
                    ,properties.pi拍錢包 == true ? "pi拍錢包" : nil
                    ,properties.一卡通 == true ? "一卡通" : nil
                    ,properties.台塑石油Pay == true ? "台塑石油Pay" : nil
                    ,properties.國旅卡 == true ? "國旅卡" : nil
                    ,properties.帝雉卡儲值 == true ? "帝雉卡儲值" : nil
                    ,properties.國旅卡 == true ? "國旅卡" : nil
                    ,properties.悠遊付 == true ? "悠遊付" : nil
                    ,properties.悠遊卡 == true ? "悠遊卡" : nil
                    ,properties.愛金卡 == true ? "愛金卡" : nil
                    ,properties.台塑石油APP == true ? "台塑石油APP" : nil
                    ,properties.台塑聯名卡 == true ? "台塑聯名卡" : nil
                    ,properties.台塑商務卡 == true ? "台塑商務卡" : nil
                    ,properties.國民旅遊卡 == true ? "國民旅遊卡" : nil
                    ,properties.Taxi卡 == true ? "Taxi卡" : nil
                ].compactMap { $0 }
            cell.detailTextLabel?.text = pay.joined(separator: "、")
            cell.detailTextLabel?.numberOfLines = 0
            cell.heightAnchor.constraint(equalToConstant: 80).isActive = true
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let dataInfo = dataInfo else { return }
        switch indexPath.row {
        case 1:
            guard let coordinate = dataInfo.coordinate else { return }
            
            let location2D = CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude)
            
            tabBarController?.selectedIndex = 0
            
            DispatchQueue.main.async{
                if let navVC = self.tabBarController?.viewControllers?[0] as? UINavigationController,
                   let mapVC = navVC.viewControllers.first as? MapVC {
                    mapVC.directionLocation = location2D
                    mapVC.txOilStationTitle = dataInfo.properties?.站名
                }
            }
        case 2:
            if let phone = dataInfo.properties?.電話
               ,let url = URL(string: "tel://\(phone)")
               ,UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        default: break
        }
    }
    
}
