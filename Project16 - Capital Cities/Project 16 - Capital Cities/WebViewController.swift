//
//  WebViewController.swift
//  Project 16 - Capital Cities
//
//  Created by Berserk on 02/11/2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak private var webView: WKWebView!
    
    var capitalTitle: String?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUrl()
    }
    
    // MARK: - Methods
    
    private func loadUrl() {
        
        if let unwrappedCapitalTitle = capitalTitle?.lowercased(), let url = URL(string: "https://fr.wikipedia.org/wiki/\(unwrappedCapitalTitle)") {
            webView.load(URLRequest(url: url))
        }
    }
    
}

