//
//  MyFlutterFactory.swift
//  Runner
//
//  Created by zhaochao on 2020/11/2.
//

import UIKit

class MyFlutterFactory: NSObject, FlutterPlatformViewFactory {
    
    var messenger: FlutterBinaryMessenger?
    
    init(messenger: FlutterBinaryMessenger) {
        super.init()
        self.messenger = messenger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return MyFlutterView(frame, viewID: viewId, args: args, messenger: messenger)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

}
 
