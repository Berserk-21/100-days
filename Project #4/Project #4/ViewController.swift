//
//  ViewController.swift
//  Project #4
//
//  Created by Berserk on 03/09/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Properties
    
    var webView: WKWebView!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupWebView()
        setupNavBar()
    }
    
    // MARK: - Methods
    
    private func setupWebView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        guard let url = URL(string: "https://www.hackingwithswift.com") else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }

    @objc private func openTapped() {
        
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage(action:)))
        alertController.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage(action:)))
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.present(alertController, animated: true)
    }
    
    private func openPage(action: UIAlertAction) {
        
        guard let website = action.title else { return }
        let urlString = "https://\(website)"
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        title = webView.title
    }
}

