//
//  ViewController.swift
//  Project21 - Local Notifications
//
//  Created by Berserk on 10/11/2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocalNotification))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocalNotification))
    }

    private func registerNotificationsCategory() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "tell me more")
        let remind = UNNotificationAction(identifier: "remind", title: "remind me later")
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    private func addLocalNotification(delay: Bool = false) {
        
        registerNotificationsCategory()
        
        let timeInterval: TimeInterval
        if delay {
            timeInterval = 86400
        } else {
            timeInterval = 5
        }
        
        // Use a timeInterval to trigger a local notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Wake up!"
        content.body = "Time to start a new day 😎"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["userID": "whateverID"]
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request)
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
                
        addLocalNotification()
    }
    
    // MARK: - UNUserNotificationCenter Delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let userID = userInfo["userID"] as? String {
            
            let title: String
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                title = "Default action tapped, open app"
            case "show":
                title = "The alarm is set every day at 3pm"
            case "remind":
                title = "remind me later"
                addLocalNotification(delay: true)
            default:
                title = "unrecognised action"
                break
            }
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
        
        completionHandler()
    }
}

