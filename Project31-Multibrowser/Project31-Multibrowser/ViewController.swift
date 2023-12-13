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
    
    private var selectedWebView: WKWebView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addressBar.delegate = self
        
        setDefaultTitle()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButton))
        
        navigationItem.rightBarButtonItems = [deleteButton, addButton]
    }
    
    // MARK: - Setup Layout

    private func setDefaultTitle() {
        
        title = "Multibrowser"
    }
    
    // MARK: - Custom Methods
    /// Adds a border width to identify visually the selected or currently active webview
    private func didSelect(webView: WKWebView) {
        
        selectedWebView = webView
        
        stackView.arrangedSubviews.forEach({ $0.layer.borderWidth = 0 })
        
        selectedWebView?.layer.borderWidth = 5.0
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
        
        stackView.removeArrangedSubview(webView)
        webView.removeFromSuperview()
        
        if let firstArrangedSubview = stackView.arrangedSubviews.first as? WKWebView {
            didSelect(webView: firstArrangedSubview)
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
        if let unwrappedSelectedWebView = selectedWebView, let text = textField.text, let url = URL(string: "https://\(text)") {
            unwrappedSelectedWebView.load(URLRequest(url: url))
        } else {
            print("There was an error loading a custom url")
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

