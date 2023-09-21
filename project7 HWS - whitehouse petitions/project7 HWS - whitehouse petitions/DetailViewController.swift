//
//  DetailViewController.swift
//  project7 HWS - whitehouse petitions
//
//  Created by Berserk on 21/09/2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    private var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHtml()
    }
    
    private func loadHtml() {
        guard let body = detailItem?.body else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
