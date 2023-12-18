//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by Berserk on 08/11/2023.
//

import UIKit
import MobileCoreServices

final class ActionViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet private var contentTextView: UITextView!
    
    private var pageTitle: String = ""
    private var pageURL: String = ""

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Custom Methods
    
    private func getJsData() {
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    
                    if let title = javaScriptValues.object(forKey: "title") as? String, let url = javaScriptValues.object(forKey: "URL") as? String {
                        
                        self?.pageTitle = title
                        self?.pageURL = url
                        
                        DispatchQueue.main.async {
                            
                            self?.title = self?.pageTitle
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func adjustKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        contentTextView.scrollIndicatorInsets = contentTextView.contentInset
        
        let selectedRange = contentTextView.selectedRange
        contentTextView.scrollRangeToVisible(selectedRange)
    }

    @IBAction func done() {
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": contentTextView.text ?? "error"]
        
        
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }

}
