//
//  MapVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/4/16.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit
import GoogleMobileAds

class MapVC: UIViewController {
    let mapView = MKMapView()
    let tabbar = UITabBarController()
    let vm: FormosaViewModel
    var txOilStationTitle: String?
    var directionLocation: CLLocationCoordinate2D? {
        didSet{
            navigateTo(directionLocation!)
        }
    }
    
    
    let btnLocation: UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let img = UIImage(systemName: "location.circle", withConfiguration: config)
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(tapLocationBtn), for: .touchUpInside)
        return btn
    }()
    
    let btnLocationBackground: UIView = {
        let bg = UIView()
        bg.backgroundColor = .white
        bg.layer.cornerRadius = 20 // 半徑設定成寬度/2
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.shadowOpacity = 0.2
        bg.layer.shadowOffset = CGSize(width: 0, height: 2)
        bg.layer.shadowRadius = 10
        return bg
    }()
    
    let btnNearList: UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let img = UIImage(systemName: "fuelpump.fill", withConfiguration: config)
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(tapNearListBtn), for: .touchUpInside)
        return btn
    }()
    
    let btnNearListBackground: UIView = {
        let bg = UIView()
        bg.backgroundColor = .white
        bg.layer.cornerRadius = 20 // 半徑設定成寬度/2
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.shadowOpacity = 0.2
        bg.layer.shadowOffset = CGSize(width: 0, height: 2)
        bg.layer.shadowRadius = 10
        return bg
    }()
    
    let btnDisfilter: UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let img = UIImage(systemName: "eraser.line.dashed", withConfiguration: config)
        btn.setImage(img, for: .normal)
        btn.tintColor = .disRed
        btn.addTarget(self, action: #selector(tapDisFilterBtn), for: .touchUpInside)
        return btn
    }()
    
    let btnDisfilterBackground: UIView = {
        let bg = UIView()
        bg.backgroundColor = .white
        bg.layer.cornerRadius = 20 // 半徑設定成寬度/2
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.shadowOpacity = 0.2
        bg.layer.shadowOffset = CGSize(width: 0, height: 2)
        bg.layer.shadowRadius = 10
        return bg
    }()
    
    var isHiddenDisFilterBtn: Bool = true {
        didSet {
            btnDisfilter.isHidden = isHiddenDisFilterBtn
            btnDisfilterBackground.isHidden = isHiddenDisFilterBtn
        }
    }
    
    var bannerView = BannerView()
    
    init(viewModel: FormosaViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(PinMKAView.self, forAnnotationViewWithReuseIdentifier: PinMKAView.reuseID)
        setupMapViewUI()
        mapView.delegate = self
        loadingCurrentLoacation()
        setupAD()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        vm.filterCallBack = { [weak self] filterData in
            guard let annotationsToRemove = self?.mapView.annotations else { return }
            print(filterData)
            let filterFeatures = filterData.compactMap { $0.feature }
            self?.putStationMarker(filterFeatures)
            self?.isHiddenDisFilterBtn = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupMapViewUI() {
        view.addSubview(mapView)
        view.addSubview(bannerView)
        view.addSubview(btnLocationBackground)
        btnLocationBackground.addSubview(btnLocation)
        view.addSubview(btnNearListBackground)
        btnNearListBackground.addSubview(btnNearList)
        view.addSubview(btnDisfilterBackground)
        btnDisfilterBackground.addSubview(btnDisfilter)
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {
            vm.recordLocation()
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bannerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        btnLocationBackground.snp.makeConstraints { make in
            make.bottom.equalTo(bannerView.snp.top).offset(-16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            make.height.width.equalTo(50)
        }
        
        btnLocation.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        btnNearListBackground.snp.makeConstraints { make in
            make.bottom.equalTo(btnLocationBackground.snp.top).offset(-8)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            make.height.width.equalTo(50)
        }
        
        btnNearList.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        btnDisfilterBackground.snp.makeConstraints { make in
            make.bottom.equalTo(btnNearListBackground.snp.top).offset(-8)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            make.height.width.equalTo(50)
        }
        
        btnDisfilter.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        btnDisfilterBackground.isHidden = true
        btnDisfilter.isHidden = true
        MobileAds.shared.start()
        // Initialize the Google Mobile Ads SDK.
        
    }
    
    func setupAD() {
        bannerView.delegate = self
        bannerView.adSize = currentOrientationAnchoredAdaptiveBanner(width: 375)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(Request())
    }
    
    private func loadingCurrentLoacation() {
        mapView.showsUserLocation = true
        vm.locationCallBack = { [weak self] currentLocation in
            let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                                longitude: currentLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: center, span: span)
            self?.mapView.setRegion(region, animated: true)
        }
        vm.recordLocation()
    }
    
    private func putStationMarker(_ feature: [Feature]? = nil) {
        var annotations = [StagtionMKA]()
        
        if let feature = feature {
            annotations = vm.transToMKA(feature) ?? []
        } else {
            annotations = vm.parserGeoJSONPoint() ?? []
        }
        
        guard !annotations.isEmpty else { return }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
    }
    
    @objc func tapLocationBtn() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {
            vm.recordLocation()
        } else {
            vm.locationManager.requestWhenInUseAuthorization()
        }
        vm.locationCallBack = { [weak self] locate in
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: locate.coordinate, span: span)
            self?.mapView.setRegion(region, animated: true)
        }
    }
    
    @objc func tapNearListBtn(){
        let listVC = OilNearListVC(viewModel: vm)
        present(listVC, animated: true, completion: nil)
    }
    
    @objc func tapDisFilterBtn(){
        vm.filterData = nil
        putStationMarker()
        isHiddenDisFilterBtn = true
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

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let visibleMapRect = mapView.visibleMapRect
        if let filterData = vm.filterData {
            let data = filterData.features
            putStationMarker(data)
        } else {
            putStationMarker()
        }
        let allAnnotations = mapView.annotations
        // 只保留畫面內的站點
        let filteredAnnotations = allAnnotations.filter { annotation in
            let point = MKMapPoint(annotation.coordinate)
            return visibleMapRect.contains(point)
        }

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(filteredAnnotations)
        
    }
    
    func navigateTo(_ coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = txOilStationTitle
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = PinMKAView.reuseID
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PinMKAView
        view?.tappedCallOut = { [weak self] stationInfo in
            let vc = StationDetailVC()
            /*
            self?.vm.imageCallBack = { [weak self] image in
                DispatchQueue.main.async {
                    vc.topImageView.image = image
                }
            }
            if let id = stationInfo.properties?.place_id {
                self?.vm.fetchStationPhoto(id: id)
            }
             */
            vc.configure(data: stationInfo)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        if view == nil {
            view = PinMKAView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
    
    
}

extension MapVC: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
      print(#function + ": " + error.localizedDescription)
    }

    func bannerViewDidRecordClick(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
      print(#function)
    }

    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
      print(#function)
    }
}
