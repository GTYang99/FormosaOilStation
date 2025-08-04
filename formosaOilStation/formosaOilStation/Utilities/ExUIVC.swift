//
//  ExUIVC.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/8/4.
//

import Foundation
import UIKit

extension UIViewController {
    func isDeviceWithHomeButton() -> Bool { //判斷是否為home鍵機型
        if let window = UIApplication.shared.windows.first {
            let bottomSafeArea = window.safeAreaInsets.bottom
            return bottomSafeArea == 0
        }
        return false
    }
    func dismissAnyAlertControllerIfPresent() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              var topVC = window.rootViewController?.presentedViewController else {
            return
        }

        while topVC.presentedViewController != nil {
            topVC = topVC.presentedViewController!
        }

        if topVC.isKind(of: UIAlertController.self) {
            topVC.dismiss(animated: false, completion: nil)
        }
    }
    
    func configureNaviagationItemBack(for viewController: UIViewController){
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = .gray200
        barAppearance.shadowColor = nil
        barAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.black as Any
        ]

        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backToMainPage)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc private func backToMainPage() {
        navigationController?.popViewController(animated: true)
    }
}

enum AlertControllerUtil {
    private static let tintColor = UIColor.systemBlue

    static func singleHintAlert(
        _ targetVC: UIViewController,
        title: String,
        message: String? = nil,
        response: String = "好",
        resColor: UIColor? = UIColor.systemBlue,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = resColor
        alert.addAction(UIAlertAction(title: response, style: .default, handler: handler))
        targetVC.present(alert, animated: true, completion: nil)
    }
    static func singleHintAlertRetrun(
        _ targetVC: UIViewController,
        title: String,
        message: String? = nil,
        response: String = "好",
        resColor: UIColor? = UIColor.systemBlue,
        handler: ((UIAlertAction) -> Void)? = nil
    )->UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = resColor
        alert.addAction(UIAlertAction(title: response, style: .default, handler: handler))
        targetVC.present(alert, animated: true, completion: nil)
        return alert
    }
    static func noActionAlert(
        _ targetVC: UIViewController,
        title: String,
        message: String? = nil,
        resColor: UIColor? = UIColor.systemBlue
    ) -> UIViewController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = resColor
        targetVC.present(alert, animated: true, completion: nil)
        return alert
    }

    static func askForTrueAlert(
        _ targetVC: UIViewController,
        title: String,
        message: String? = nil,
        isDanger: Bool = false,
        responseTrue: String = "是",
        responseFalse: String = "取消",
        doIfTrue: ((UIAlertAction) -> Void)?,
        doIfFalse: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = tintColor

        let style: UIAlertAction.Style = isDanger ? .destructive : .default
        let falseAction = UIAlertAction(title: responseFalse, style: .default, handler: doIfFalse)
        let trueAction = UIAlertAction(title: responseTrue, style: style, handler: doIfTrue)
        alert.addAction(falseAction)
        alert.addAction(trueAction)

        targetVC.present(alert, animated: true, completion: nil)
    }

    static func waitingAlert(_ targetVC: UIViewController, title: String, mode: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        let animationView = UIActivityIndicatorView(style: .large)

        let animationViewY: CGFloat = mode == "errorMode" ? 120 : 80
        let alertHeight: CGFloat = mode == "errorMode" ? 160 : 120

        animationView.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        animationView.center = CGPoint(x: 135, y: animationViewY) // alertView's width is 270 , no why
        animationView.tintColor = .link

        // Add the animation to the alert's view
        alert.view.addSubview(animationView)

        // Start animating
        animationView.startAnimating()

        let constHeight = NSLayoutConstraint(
            item: alert.view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: alertHeight
        )
        alert.view.addConstraint(constHeight)

        targetVC.present(alert, animated: true, completion: nil)
        return alert
    }

    static func bottomAlert(
        _ targetVC: UIViewController,
        title: String?,
        message: String? = nil,
        responseTrue: String = "是",
        responseFalse: String = "取消",
        doIfTrue: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        alertController.view.tintColor = tintColor

        let cancelAction = UIAlertAction(
            title: responseFalse,
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(
            title: responseTrue,
            style: .default,
            handler: doIfTrue
        )
        alertController.addAction(okAction)

        // 顯示提示框
        targetVC.present(alertController, animated: true, completion: nil)
    }

    // progress alert
    static func progressAlert(_ targetVC: UIViewController, title: String) -> CustomProgressAlert {
        let alert = CustomProgressAlert(title: title, message: nil, preferredStyle: .alert)
        alert.progress = 0
        alert.progressColor = .normal
        targetVC.present(alert, animated: true, completion: nil)
        return alert
    }
}

class CustomProgressAlert: UIAlertController {
    // ui
    private let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 238, height: 4))

    // progress value
    var progress: Float {
        get {
            progressView.progress
        }
        set(val) {
            progressView.setProgress(val, animated: true)
        }
    }

    // color
    private var errorState: IsError = .normal
    var progressColor: IsError {
        get {
            errorState
        }
        set(val) {
            errorState = val
            if val == .normal {
                progressView.progressTintColor = UIColor(named: "AccentColor")
            } else if val == .error {
                progressView.progressTintColor = UIColor(named: "unacceptRed")
            }
        }
    }

    enum IsError: Int {
        case normal = 0
        case error = 1
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // progress view
        progressView.center = CGPoint(x: 135, y: 80)
        progressView.layer.cornerRadius = 2
        view.addSubview(progressView)

        let constHeight = NSLayoutConstraint(
            item: view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: .none,
            attribute: .height,
            multiplier: 1,
            constant: 120
        )
        view.addConstraint(constHeight)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
