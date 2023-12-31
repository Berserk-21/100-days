//
//  ViewController.swift
//  Project #4
//
//  Created by Berserk on 03/09/2023.
//

import UIKit
import WebKit

final class WebviewViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Properties
    
    private var webView: WKWebView!
    private var progressiveView: UIProgressView!
    
    var selectedWebsite: String?
    
    private var websites: [String] = ["apple", "hackingwithswift", "amazon"]

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupWebView()
        setupNavBar()
        setupToolBar()
        addProgressObserver()
    }
    
    // MARK: - Setup Layout
    
    private func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }
    
    private func setupToolBar() {
        
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        progressiveView = UIProgressView(progressViewStyle: .default)
        progressiveView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressiveView)
        
        let goBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(goBack))
        let goForwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .done, target: self, action: #selector(goForward))
        
        toolbarItems = [flexibleSpacer, goBackButton, flexibleSpacer, goForwardButton, flexibleSpacer, progressButton, flexibleSpacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: - Custom Methods
    
    private func setupWebView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        guard let unwrappedSelectedWebsite = selectedWebsite, let url = URL(string: "https://www.\(unwrappedSelectedWebsite).com") else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func addProgressObserver() {
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressiveView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // MARK: - Actions

    @objc private func openTapped() {
        
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for website in websites {
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage(action:)))
        }
        
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.present(alertController, animated: true)
    }
    
    @objc private func refresh() {
        webView.reload()
    }
    
    @objc private func goBack() {
        webView.goBack()
    }
    
    @objc private func goForward() {
        webView.goForward()
    }
    
    private func openPage(action: UIAlertAction) {
        
        guard let website = action.title else { return }
        let urlString = "https://www.\(website).com"
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        guard let unwrappedHost = url?.host else {
            decisionHandler(.cancel)
            return
        }
        
        for website in websites {
            if unwrappedHost.contains(website) {
                decisionHandler(.allow)
                return
            }
        }
        
        let ac = UIAlertController(title: "This website is blocked", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))

        present(ac, animated: true)

        decisionHandler(.cancel)
    }
}

