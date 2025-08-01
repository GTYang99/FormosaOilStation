//
//  NearVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/25.
//

import UIKit
import SnapKit
import CoreLocation

class NearVC: UIViewController {
    let tbNearby = UITableView()
    let vm = FormosaViewModel()
    var distanceFeatures: [FeatureWithDistance]? {
        didSet {
            tbNearby.reloadData()
        }
    }
    let detailView = NearStationDetailVC()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tbNearby.delegate = self
        tbNearby.dataSource = self
        tbNearby.dequeueReusableCell(withIdentifier: "NearStationCell")
        setupTabelView()
        tbDataBinding()
    }
    
    func setupTabelView(){
        tbNearby.register(NearStationCell.self, forCellReuseIdentifier: "NearStationCell")

        
        view.addSubview(tbNearby)
        view.backgroundColor = .white
        
        tbNearby.backgroundColor = .white
        tbNearby.separatorStyle = .none
        
        tbNearby.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
        }
    }
    
    func tbDataBinding(){
        vm.decoderCallBack = { [weak self] oilStations in
            guard let self = self
                , let features = oilStations.features else { return }
            let sortedFeatures = vm.sortFeaturesByDistance(features)
            let distanceFeatures = vm.distanceFeatures(sortedFeatures, near: 10)
            
            self.distanceFeatures = distanceFeatures
            self.tbNearby.reloadData()
        }
        vm.recordLocation()
        vm.locationCallBack = { [weak self] _ in
            self?.vm.parserGeoJSONPoint()
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

extension NearVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let data = data else { return 0 }
        guard let data = distanceFeatures else { return 0 }
        return data.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = distanceFeatures  else { return UITableViewCell() }
        let feature = data[indexPath.row].feature
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearStationCell", for: indexPath) as! NearStationCell
        cell.configure(with: feature)
        let distance = (distanceFeatures?[indexPath.row].distance ?? 0) / 1000.0
        if distance < 100 {
            cell.distance.text = String(format: "%.1f 公里", distance)
        }
        if distance >= 100 {
            cell.distance.text = String(format: "%.0f 公里", distance)
        }
        
        cell.onSelectStation = { [weak self]  location2D in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 0

                if let navVC = self.tabBarController?.viewControllers?[0] as? UINavigationController,
                   let mapVC = navVC.viewControllers.first as? MapVC {
                    mapVC.directionLocation = location2D
                    mapVC.txOilStationTitle = feature.properties?.站名
                }

            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //guard let dataInfo = self.data?[indexPath.row] else { return }
        guard let dataInfo = self.distanceFeatures?[indexPath.row].feature else { return }
        
        let detailVC = NearStationDetailVC()
        detailVC.dataInfo = dataInfo
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
