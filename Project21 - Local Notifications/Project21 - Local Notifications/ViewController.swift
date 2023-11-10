//
//  ViewController.swift
//  Project21 - Local Notifications
//
//  Created by Berserk on 10/11/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocalNotification))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleNotification))
    }

    // MARK: - Actions
    
    @objc private func registerLocalNotification() {
        
        
    }
    
    @objc private func scheduleNotification() {
        
        
    }
}

