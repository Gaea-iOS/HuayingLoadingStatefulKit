//
//  ViewController.swift
//  HuayingStatefulViewMachine
//
//  Created by lzc1104 on 04/25/2018.
//  Copyright (c) 2018 lzc1104. All rights reserved.
//

import UIKit
import HuayingStatefulViewMachine
import SnapKit
import WebKit

class ViewController: UIViewController,DropDownAlertProtocol {
    
    @IBOutlet weak var drop: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    @IBAction func onclict(_ sender: Any) {
        let error = NSError.init(domain: "666", code: 100, userInfo: [NSLocalizedDescriptionKey: "6666666666"])
        self.dropAlert(error: error)
        
    }
}

class ViewControllerPure: UIViewController, ViewStateMachineProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.testState()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func testState(times: Int = 0) {
        self.state = ViewErrorState(error: NSError.init(domain: "666", code: 100, userInfo: [NSLocalizedDescriptionKey: "发生\(times)次错误"]), resume: {
            if times == 3 {
                self.state = .normal()
                return
            }
            self.state = .loading("加载请求中...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
                DispatchQueue.main.async {
                    self.testState(times: times + 1)
                }
            })
        })
    }

}



class ViewControllerTable: UIViewController {
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        table.separatorInset = UIEdgeInsets.zero
        table.layoutMargins = UIEdgeInsets.zero
        table.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        self.testState()
        
    }
    
    func testState(times: Int = 0) {
        self.table.state = ViewErrorState(error: NSError.init(domain: "666", code: 100, userInfo: [NSLocalizedDescriptionKey: "发生\(times)次错误"]), resume: {
            if times == 3 {
                self.table.state = .normal()
                return
            }
            self.table.state = .loading("加载列表中...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
                DispatchQueue.main.async {
                    self.testState(times: times + 1)
                }
            })
        })
    }
    
}

class ViewControllerWeb: UIViewController {
     var webview: ProxyWebview!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview = ProxyWebview(frame: CGRect.zero)
        self.view.addSubview(self.webview)
        self.webview.snp.makeConstraints { (make) in

            make.edges.equalToSuperview()
        }
        let urlString = "https://google.com"
        let url = URL.init(string: urlString)!
        let request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10)
        self.webview.load(request)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.testState()
        
    }
    
    func testState(times: Int = 0) {
        
    }
    
}

