//
//  ViewController.swift
//  Project28-SecretSwift
//
//  Created by Berserk on 30/11/2023.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties

    @IBOutlet weak var secretTextView: UITextView!
    
    private let secretMessageKey: String = "SecretMessageKey"
    private let passwordKey: String = "passwordKey"
    
    private let hiddenTitle: String = "Nothing to see here"
    private let revealedTitle: String = "Secret stuff!"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNotificationCenterObservers()
        setupLayout()
        setupAppPassword()
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        
        title = hiddenTitle

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSecretMessage))
    }
    
    private func setupNotificationCenterObservers() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func unlockSecretMessage() {
        
        secretTextView.isHidden = false
        title = revealedTitle
        
        if let text = KeychainWrapper.standard.string(forKey: secretMessageKey) {
            secretTextView.text = text
        }
    }
    
    private func setupAppPassword() {
        
        guard KeychainWrapper.standard.string(forKey: passwordKey) == nil else { return }
        
        let alertController = UIAlertController(title: "Create password", message: "Create a password to use this app", preferredStyle: .alert)
        alertController.addTextField { [weak self] tf in
            if let text = tf.text, !text.isEmpty, let unwrappedSelf = self {
                KeychainWrapper.standard.set(text, forKey: unwrappedSelf.passwordKey)
            }
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            if let tf = alertController.textFields?.first {
                if let text = tf.text, !text.isEmpty, let unwrappedSelf = self {
                    KeychainWrapper.standard.set(text, forKey: unwrappedSelf.passwordKey)
                }
            }
        }))
        present(alertController, animated: true)
    }
    
    private func checkAppPassword() {
        
        guard let appPassword = KeychainWrapper.standard.string(forKey: passwordKey) else {
            print("No password defined for the app")
            setupAppPassword()
            return
        }
        
        let alertController = UIAlertController(title: "Password", message: "Enter the password defined for this app", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            
            if let unwrappedSelf = self, let tf = alertController.textFields?.first {
                if let text = tf.text, !text.isEmpty {
                    
                    if appPassword == text {
                        unwrappedSelf.unlockSecretMessage()
                    } else {
                        let alertController = UIAlertController(title: "Wrong password", message: nil, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        alertController.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                            unwrappedSelf.checkAppPassword()
                        }))
                        unwrappedSelf.present(alertController, animated: true)
                    }
                }
            }
        }))
        
        self.present(alertController, animated: true)
    }
    
    @objc private func saveSecretMessage() {
        
        guard secretTextView.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secretTextView.text, forKey: secretMessageKey)
        secretTextView.resignFirstResponder()
        secretTextView.isHidden = true
        title = hiddenTitle
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAuthenticate(_ sender: Any) {
        
        let context = LAContext()
        context.localizedFallbackTitle = "Utiliser le mot de passe"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, err in
                
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else if let authError = err as? LAError, authError.code == .userFallback {
                        
                        self?.checkAppPassword()
                        
                    } else {
                        let alertController = UIAlertController(title: "Authentication failed", message: "You could not be verified. Try again!", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alertController, animated: true)
                    }
                }
            }
        } else {
            
            let alertController = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentification.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
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

