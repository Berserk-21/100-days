//
//  ViewController.swift
//  Project31-Multibrowser
//
//  Created by Berserk on 13/12/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Properties

    @IBOutlet private weak var addressBar: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDefaultTitle()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButton))
        
        navigationItem.rightBarButtonItems = [deleteButton, addButton]
    }
    
    // MARK: - Custom Methods

    private func setDefaultTitle() {
        
        title = "Multibrowser"
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddButton() {
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let urlString: String = "https://www.hackingwithswift.com"
        
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        } else {
            print("There was an error with the url: \(urlString)")
        }
    }
    
    @objc private func didTapDeleteButton() {
        
        
    }
}

