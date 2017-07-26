//
//  TXExtUIViewController.swift
//  Heymow
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit
import Photos
@objc
public protocol ResultForViewControllerDelegate {
    func onViewControllerResult(_ sender: AnyClass, result: [String: Any])
}

extension UIViewController: UIGestureRecognizerDelegate {
    func initNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func setCustomBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "btn_back"), style: .plain, target: self, action: #selector(UIViewController.popBack(_:)))
        backButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setCustomDismissButton() {
        // dismiss view controller
        let backButton = UIBarButtonItem(image: UIImage(named: "btn_back"), style: .plain, target: self, action: #selector(UIViewController.dismissView(_:)))
        backButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    /** 初始化导航栏右侧的按钮 */
    func setNaviRightText(_ rightText: String, textColor: UIColor = UIColor.white) {
        var button: UIButton!
        if self.navigationItem.rightBarButtonItem == nil {
            button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
            //        button.setTitleColor(TXSettings.subColor, forState: .Normal)
            button.setTitleColor(ZCConstants.bgColor, for: .highlighted)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16) //UIFont.defaultFontOfSize(16, fitScreen: true)
            button.addTarget(self, action:#selector(UIViewController.rightTextClicked(_:)), for: UIControlEvents.touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        } else {
            button = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        }
        
        button.setTitle(rightText, for: UIControlState())
        button.setTitleColor(textColor, for: UIControlState())
        button.sizeToFit()
    }
    
    /** 初始化导航栏右侧的按钮 */
    func setNaviRightImage(_ rightImage: UIImage) {
        initNavigationBar()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        button.setImage(rightImage, for: UIControlState())
        button.tintColor = UIColor.clear
        button.addTarget(self, action:#selector(UIViewController.rightTextClicked(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    /** 添加tablefooter */
    func initFooterViewWith(_ title: String, marginTop: CGFloat = 0) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64))
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: marginTop, width: view.frame.width, height: 48)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)//UIFont.dcBlackFontOfSize(14, fitScreen: true)
        footerView.addSubview(button)
        button.addTarget(self, action: #selector(tablefooterButtonPressed), for: .touchUpInside)
        return footerView
    }
    
    func tablefooterButtonPressed(_ sender: UIButton) {
        
    }
    
    func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    @IBAction func popBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightTextClicked(_ sender: AnyObject) {
        
    }
    
    //实现navigation leftBar自定义，跟左划动作同时存在
}

extension UIViewController {
    func checkPhotoAuthorization(_ authorizedCallback : (() -> Void)?){
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized {
            authorizedCallback!()
        }
        
        else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (afterStatus) in
                if afterStatus == .denied {
                    if self.navigationController != nil {
                        DispatchQueue.main.async {
                            self.navigationController?.view.makeToast("您未授权访问照片，将不能正常使用此功能。。。")
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.view.makeToast("您未授权访问照片，将不能使用此功能。。。")
                        }
                    }
                }
                else if afterStatus == .authorized {
                    DispatchQueue.main.async {
                        authorizedCallback!()
                    }
                }
            })
        }
        else {
            let alertView = UIAlertController(title: "提示", message: "为使用此功能，请允许奇迹之树访问照片", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "设置", style: .default, handler: { (action) -> Void in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(url!)
            }))
            alertView.addAction(UIAlertAction(title: "不处理", style: .cancel, handler: nil))
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func checkCameraAuthorization(_ authorizedCallback : (() -> Void)?) {
        let status : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == .authorized {
            authorizedCallback!()
        }
        
        else if status == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (authorized) in
                if !authorized {
                    if self.navigationController != nil {
                        DispatchQueue.main.async {
                            self.navigationController?.view.makeToast("您未授权访问照相机，将不能正常使用此功能。。。")
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.view.makeToast("您未授权访问照相机，将不能正常使用此功能。。。")
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        authorizedCallback!()
                    }
                }
            })
        }
            
        else if status == .denied {
            let alertView = UIAlertController(title: "提示", message: "为使用此功能，请在设置里面允许奇迹之树访问相机", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "设置", style: .default, handler: { (action) -> Void in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(url!)
            }))
            alertView.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: nil))
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var DescriptiveName = "tx_resultDelegate"
    }
    
    weak var resultDelegate: ResultForViewControllerDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? ResultForViewControllerDelegate
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as ResultForViewControllerDelegate?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    weak var mApplication: AppDelegate? {
        get {
            return UIApplication.shared.delegate as? AppDelegate
        }
        
        set {
            
        }
    }
}
