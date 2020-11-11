import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    if let registrar = self.registrar(forPlugin: "plugins.flutter.io/custom_platform_view_plugin") {
        let factory = MyFlutterFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "plugins.flutter.io/custom_platform_view")
    }
    //flutter中使用Sharedpreferences保存数据的key自动加了一个flutter.的前缀，所以在iOS中要取值和存值的话需要加上前缀。
    if let userName = UserDefaults.standard.string(forKey: "flutter.userName") {
        print("userName", userName)
    }
    if let password = UserDefaults.standard.string(forKey: "flutter.password") {
        print("password", password)
    }
    
    UserDefaults.standard.setValue("flutter.password", forKey: "flutter.password")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
