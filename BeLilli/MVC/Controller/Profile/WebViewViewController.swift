//
//  WebViewViewController.swift
//  BeLilli
//
//  Created by apple on 10/11/21.
//

import UIKit
import WebKit


class WebViewViewController: BaseViewController {
    
    @IBOutlet weak var webView : WKWebView!
    
    var titletxt = ""
    var urlString = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle.text = titletxt
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }


}
