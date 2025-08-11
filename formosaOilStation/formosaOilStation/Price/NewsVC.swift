//
//  NewsVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/8/8.
//

import UIKit
import WebKit

class NewsVC: UIViewController {
    private var urlString: String?
    private let webView = WKWebView()
    
    init(shows url: String? = nil) {
        self.urlString = url
        super.init(nibName: nil, bundle: nil)
        webView.loadHTMLString("", baseURL: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI () {
        view.addSubview(webView)
        if let urlString = urlString, let mainURL = URL(string: "\(MainAPI.mainURL)/\(urlString)" ) {
            webView.load(URLRequest(url: mainURL))
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.bottom.trailing.equalToSuperview()
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
