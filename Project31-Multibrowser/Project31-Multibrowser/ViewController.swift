//
//  ViewController.swift
//  Project31-Multibrowser
//
//  Created by Berserk on 13/12/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    // MARK: - Properties

    @IBOutlet private weak var addressBar: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var emptyLayoutLabel: UILabel!
    
    private var selectedWebView: WKWebView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addressBar.delegate = self
        
        setupLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        setDefaultTitle()
        addRightBarButtons()
    }

    private func setDefaultTitle() {
        
        title = "Multibrowser"
        addressBar.text = "https://www."
    }
    
    private func addRightBarButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButton))
        
        navigationItem.rightBarButtonItems = [deleteButton, addButton]
    }
    
    // MARK: - Custom Methods
    /// Adds a border width to identify visually the selected or currently active webview.
    private func didSelect(webView: WKWebView) {
        
        selectedWebView = webView
        
        stackView.arrangedSubviews.forEach({ $0.layer.borderWidth = 0 })
        
        selectedWebView?.layer.borderWidth = 5.0
        
        updateUI(for: webView)
    }
    
    /// Sets the webview title as viewController title and website title as addressBar text.
    private func updateUI(for webView: WKWebView?) {
        
        updateEmptyLayout()
        
        guard let unwrappedWebView = webView else {
            setDefaultTitle()
            return
        }
        
        title = unwrappedWebView.title
        addressBar.text = unwrappedWebView.url?.absoluteString
    }
    
    private func updateEmptyLayout() {
        
        if stackView.arrangedSubviews.isEmpty {
            emptyLayoutLabel.isHidden = false
        } else {
            emptyLayoutLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.layer.borderColor = UIColor.blue.cgColor
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapWebView(_:)))
        tapRecognizer.delegate = self
        
        webView.addGestureRecognizer(tapRecognizer)
        
        stackView.addArrangedSubview(webView)
        
        let urlString: String = "https://www.hackingwithswift.com"
        
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else {
            print("There was an error with the url: \(urlString)")
        }
    }
    
    @objc private func didTapDeleteButton() {
        
        guard let webView = selectedWebView else {
            print("There's no selectedWebView, can't remove it")
            return
        }
        
        webView.removeFromSuperview()
        
        if let firstArrangedSubview = stackView.arrangedSubviews.first as? WKWebView {
            didSelect(webView: firstArrangedSubview)
        } else {
            selectedWebView = nil
            updateUI(for: nil)
        }
    }
    
    @objc private func didTapWebView(_ recognizer: UITapGestureRecognizer) {
        if let webView = recognizer.view as? WKWebView {
            didSelect(webView: webView)
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let unwrappedSelectedWebView = selectedWebView else {
            emptyLayoutLabel.text = "First tap on the add button then type a website url"
            return true
        }
        
        if let text = textField.text, let url = URL(string: text) {
            unwrappedSelectedWebView.load(URLRequest(url: url))
        } else {
            print("Couldn't load the website, please double check the url")
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // Select the webview when it finishes loading
        didSelect(webView: webView)
    }
}

