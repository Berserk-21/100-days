//
//  ViewController.swift
//  Project #4
//
//  Created by Berserk on 03/09/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let url = URL(string: "https://www.hackingwithswift.com") else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }


}

