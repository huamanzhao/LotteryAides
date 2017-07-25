//
//  TXExtUIViewController.swift
//  Heymow
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 hebtx. All rights reserved.
//

import UIKit
import Photos
import HealthKit

@objc
public protocol TXResultForViewControllerDelegate {
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
    func setRightText(_ rightText: String, textColor: UIColor = UIColor.white) {
        var button: UIButton!
        if self.navigationItem.rightBarButtonItem == nil {
            button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
            //        button.setTitleColor(TXSettings.subColor, forState: .Normal)
            button.setTitleColor(TXSettings.bgColor, for: .highlighted)
            button.titleLabel?.font = UIFont.defaultFontOfSize(16, fitScreen: true)
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
    func setRightImage(_ rightImage: UIImage) {
        initNavigationBar()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        button.setImage(rightImage, for: UIControlState())
        button.tintColor = UIColor.clear
        button.addTarget(self, action:#selector(UIViewController.rightTextClicked(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    /** 添加标题菜单 */
    func setBaseViewController(_ navigationHeight: CGFloat, againsStatusBar: Bool = false) -> VTMagicController {
        let baseController = VTMagicController()
//        baseController.view.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        baseController.magicView.navigationInset = UIEdgeInsetsMake(0, 0, 0, 0);
        baseController.magicView.navigationColor = UIColor.black//TXSettings.bgColor
        baseController.magicView.sliderColor = TXSettings.mainColor
        baseController.magicView.separatorColor = TXSettings.bgColor
        baseController.magicView.switchStyle = .default
        baseController.magicView.layoutStyle = .center
        baseController.magicView.navigationHeight = navigationHeight
        baseController.magicView.isAgainstStatusBar = againsStatusBar
        
        baseController.magicView.itemSpacing = view.frame.width * 0.12
//        baseController.magicView.sliderWidth = view.frame.width * 0.12
        
        //如果显示状态栏，则底部减去状态栏的高度
        if !againsStatusBar {
            baseController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 44 - 20)
        }
        
        return baseController
    }
    /** 添加tablefooter */
    func initFooterViewWith(_ title: String, marginTop: CGFloat = 0) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64))
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: marginTop, width: view.frame.width, height: 48)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.dcBlackFontOfSize(14, fitScreen: true)
        footerView.addSubview(button)
        button.addTarget(self, action: #selector(tablefooterButtonPressed), for: .touchUpInside)
        return footerView
    }
    
    func tablefooterButtonPressed(_ sender: UIButton) {
        
    }
    
    func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
        
    func getCacheManager () -> TXCacheManager {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.getCacheManager()
    }

    
    func isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    @IBAction func back(_ sender: AnyObject) {
        if (self.navigationController?.popViewController(animated: true) == nil) {
            self.dismiss(animated: true, completion: nil)
        }
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
    
    func checkLocateAuthorization() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return true
        }
        
        if status == .denied || status == .restricted {
            let alertView = UIAlertController(title: "提示", message: "为能够成功分享位置，请在设置里面允许奇迹之树使用您的位置信息", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (action) -> Void in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(url!)
            }))
            
            self.present(alertView, animated: true, completion: nil)
            return false
            
        }
//        if status == .NotDetermined {
//            let locationManager = CLLocationManager()
//            locationManager.requestWhenInUseAuthorization()
//        }
        return false
    }
    
    
    /*  HealthKit权限处理
     *  功能描述：
     *  1.检察权限     2.申请权限（系统弹框）   3.再次申请权限
     */
    //检查是否进行过授权
    //如果是首次安装软件，首次调用这个函数，则请求系统弹框HealthKit授权
//    func checkHealthAuthorization(completion: (Bool) -> Void) {
//        let healthKitStore = TXUtil.getHealthStore()
//        let stepType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
//        let distanceType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
//        let heartRateType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
//        
//        let stepAuthor = healthKitStore.authorizationStatusForType(stepType)    //查询步数是否授权过
//        let distanceAuthor = healthKitStore.authorizationStatusForType(distanceType)    //查询距离是否授权过
//        let heartRateAuthor = healthKitStore.authorizationStatusForType(heartRateType)    //查询心率是否授权过
//        
//        
//        if stepAuthor == .NotDetermined || distanceAuthor == .NotDetermined || heartRateAuthor == .NotDetermined {   //未决定，说明是首次检测
//            requestHealthKitAuthority(completion)//请求系统弹框HealthKit授权
//            return
//        }
//        
//        //天坑：
//        //只要在系统弹出的健康数据选择界面做出选择，无论允许还是不允许，以后authorizationStatusForType函数只会返回SharingDenied
//        //只能再去读一遍数据，如果读不到数据，则认为没有授权
//        if stepAuthor == .SharingDenied || distanceAuthor == .SharingDenied {
//            getHealthTypeAuthorization({ (isAuthorized) in      //获取实际授权情况
//                completion(isAuthorized)
//            })
//        }
//    }
    
    //健康授权界面：系统弹框
    func requestHealthKitAuthority(_ completion: @escaping (Bool) -> Void) {
        let healthKitStore = TXUtil.getHealthStore()
        
        let typesToRead = NSSet(array:
            [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]) as! Set<HKSampleType>
        let typesToWrite = NSSet(array:[]) as! Set<HKSampleType>
        
        healthKitStore.requestAuthorization(toShare: typesToWrite, read: typesToRead, completion: { (approval, error) in
            if approval {   //不管用户选择“允许”、“不允许”这里返回的值都是true，尼玛不可理喻
                self.getHealthTypeAuthorization(completion)
            }
        })
    }
    
    //获取实际授权情况      （读取步数信息，如果返回为空，则说明没有进行授权）
    func getHealthTypeAuthorization(_ completion: @escaping (Bool) -> Void) {
        let manager = TXHealthKitManager()
        var checkedCount = 0       //检查过的类型的数量
        var unAuthorCount = 0      //未授权的类型的数量
        
        let beginDate = Date(timeIntervalSince1970: 0)    //从1970年开始读
        let endDate = Date()
        
        //三次healthkit数据请求完成后，检测是否授权
        func checkCompletion()
        {
            if checkedCount == 3 {
                if unAuthorCount > 0 {  //步数、距离没有完全授权
                    completion(false)
                }
                else {   //步数、距离完全授权
                    completion(true)
                }
            }
        }
        
        //判断能否获取到步数记录
        let stepQuery = TXSampleQuery()
        stepQuery.type  = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        stepQuery.begin = beginDate
        stepQuery.end   = endDate
        stepQuery.limit = 1
        manager.readQuantitySample(stepQuery) { (sample, error) in
            checkedCount += 1
            if error != nil && error?._code == -1 {
                unAuthorCount += 1
            }
            
            checkCompletion()
        }
        
        //判断能否获取到距离记录
        let distanceQuery = TXSampleQuery()
        distanceQuery.type  = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        distanceQuery.begin = beginDate
        distanceQuery.end   = endDate
        distanceQuery.limit = 1
        manager.readQuantitySample(distanceQuery) { (sample, error) in
            checkedCount += 1
            if error != nil && error?.code == -1 {
                unAuthorCount += 1
            }
            
            checkCompletion()
        }
        
        //判断能够获取心率数据
        let heartRateQuery = TXSampleQuery()
        heartRateQuery.type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        heartRateQuery.begin = beginDate
        heartRateQuery.end   = endDate
        heartRateQuery.limit = 1
        manager.readQuantitySample(heartRateQuery) { (sample, error) in
            checkedCount += 1
            if error != nil && error?.code ==  -1 {
                unAuthorCount += 1
            }
            
            checkCompletion()
        }
    }
    
    //健康权限打开提醒（非首次）
    func remindHealthKitAuthority() {
        //let typeStr = getTypeNameByIdentifier(type.identifier)
        let message = "为获取更佳使用体验，请打开手机设置”设置“-”隐私“-”健康“-”奇迹之树”，打开步数、距离、心率的授权"
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "知道了", style: .default) { (action) -> Void in
//            window.rootViewController?.view.makeToast("您未对HealthKit授权，无法正常使用运动统计功能")
        }
//        let ignore = UIAlertAction(title: "不再提醒", style: .Default) { (action) -> Void in
//            window.rootViewController?.view.makeToast("您未对HealthKit授权，无法正常使用此功能")
//            self.authurIgnored = true
//        }
//        let authrize = UIAlertAction(title: "设置", style: .Destructive) { (action) -> Void in
//            let url = NSURL(string: "Prefs:root=Privacy&path=HEALTH")!
//            let app = UIApplication.sharedApplication()
//            if app.canOpenURL(url) {
//                app.openURL(url)
//            }
//            else {
//                app.openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
//            }
//        }
        
        alert.addAction(cancel)
        //        alert.addAction(ignore)
        //alert.addAction(authrize)
        
//        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var DescriptiveName = "tx_resultDelegate"
    }
    
    weak var resultDelegate: TXResultForViewControllerDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? TXResultForViewControllerDelegate
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as TXResultForViewControllerDelegate?,
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
