//
//  ViewController.swift
//  Project28-SecretSwift
//
//  Created by Berserk on 30/11/2023.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties

    @IBOutlet weak var secretTextView: UITextView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    @objc private func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardRect = keyboardValue.cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secretTextView.contentInset = .zero
        } else {
            secretTextView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardRect.height - view.safeAreaInsets.bottom, right: 0.0)
        }
        
        secretTextView.scrollIndicatorInsets = secretTextView.contentInset
        
        let selectedRange = secretTextView.selectedRange
        secretTextView.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: - UITextView Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }

}

