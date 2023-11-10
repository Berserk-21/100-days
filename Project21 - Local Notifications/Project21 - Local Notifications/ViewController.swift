//
//  ViewController.swift
//  Project21 - Local Notifications
//
//  Created by Berserk on 10/11/2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocalNotification))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocalNotification))
    }

    // MARK: - Actions
    
    @objc private func registerLocalNotification() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let err = error {
                print("There was an error granting notification authorization: \(err.localizedDescription)")
            } else {
                if granted {
                    print("Amazing!")
                } else {
                    print("Why ='(")
                }
            }
        }
    }
    
    @objc private func scheduleLocalNotification() {
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Title goes here"
        content.body = "Main text goes here"
        content.categoryIdentifier = "customIdentifier"
        content.userInfo = ["customDate": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request)
    }
}

