//
//  MyFlutterView.swift
//  Runner
//
//  Created by zhaochao on 2020/11/2.
//

import UIKit


class MyFlutterView: NSObject, FlutterPlatformView {
    
    var myFlutterVC: MyFlutterViewController?
    var message: String?
    
    init(_ frame: CGRect,viewID: Int64,args :Any?,messenger :FlutterBinaryMessenger?) {
        super.init()
        guard let args = args else { return }
        print("viewID：\(viewID)")
        guard let dic = args as? [String: Any] else { return }
        self.message = dic["message"] as? String
        //创建methodChannel
        if let messenger = messenger {
            //通过viewID创建MethodChannel，解决flutter嵌入多个相同原生组件的通信问题
            let methodChannel = FlutterMethodChannel(name: "com.flutter.guide.MyFlutterView_\(viewID)", binaryMessenger: messenger)
            methodChannel.setMethodCallHandler { (call, result) in
                if call.method == "setText" {
                    if let dict = call.arguments as? [String: Any] {
                        let name = dict["name"] as? String
                        var age = dict["age"] as? Int ?? -1
                        guard let vc = self.myFlutterVC else { return }
                        age += vc.age
                        vc.age = age
                        vc.messageLabel.text = "\(name ?? "")\(age + 1)"
                    }
                } else if call.method == "getData" {
                    result(["name": "这是从原生APP传过来的数据"])
                }
            }
        }
    }
    
    func view() -> UIView {
        if let flutterVC = self.myFlutterVC {
            return flutterVC.view
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyFlutterViewController") as! MyFlutterViewController
            vc.message = self.message
            //flutter嵌套控制器的view时，需要将创建的控制器addChild到一个控制器上，否则事件不会响应
            //UIApplication.shared.keyWindow?.rootViewController?.addChild(vc)
            UIViewController.topViewController()?.addChild(vc)
            self.myFlutterVC = vc
            return vc.view
        }
    }
    
    
}

extension UIViewController {
    ///最顶层控制器
    static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = viewController as? UINavigationController,
            !navigationController.viewControllers.isEmpty
        {
            return self.topViewController(navigationController.viewControllers.last)
        } else if let tabBarController = viewController as? UITabBarController,
            let selectedController = tabBarController.selectedViewController
        {
            return self.topViewController(selectedController)
        } else if let presentedController = viewController?.presentedViewController {
            return self.topViewController(presentedController)
        }
        return viewController
    }
}
