//
//  WebViewController.swift
//  RajNews
//
//  Created by Raj on 20/06/17.
//  Copyright © 2017 Raj. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var url:String?
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     webview.loadRequest(URLRequest(url: URL(string: url!)!))
    }
}
