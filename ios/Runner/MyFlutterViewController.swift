//
//  MyFlutterViewController.swift
//  Runner
//
//  Created by zhaochao on 2020/11/2.
//

import UIKit

class MyFlutterViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var topMessageLabel: UILabel!
    
    var age = 0
    
    var message: String? {
        didSet {
            if messageLabel != nil {
                messageLabel.text = message
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.text = message
        // Do any additional setup after loading the view.
    }

    @IBAction func btnTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "提示", message: "点击原生按钮的提示", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "看到了", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
