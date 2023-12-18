//
//  ViewController.swift
//  Guess The Flag
//
//  Created by Berserk on 14/08/2023.
//

import UIKit
import UserNotifications

final class ViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet private weak var topButton: UIButton!
    @IBOutlet private weak var midButton: UIButton!
    @IBOutlet private weak var bottomButton: UIButton!
    @IBOutlet private weak var scoreBarButton: UIBarButtonItem!
    @IBOutlet private weak var numberOfQuestionsLabel: UILabel!
    
    private var numberOfQuestions: Int = 0
    private var maxNumberOfQuestions: Int = 10
    private var countries: [String] = []
    private var score: Int = 0
    private var correctAnswer: Int = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        loadCountries()
        askQuestion()
        registerLocalNotifications()
    }

    // MARK: - Setup Layout
    
    private func setupLayout() {
     
        view.backgroundColor = .lightGray

        topButton.clipsToBounds = true
        midButton.clipsToBounds = true
        bottomButton.clipsToBounds = true
        
        topButton.layer.cornerRadius = 4
        midButton.layer.cornerRadius = 4
        bottomButton.layer.cornerRadius = 4
        
        topButton.layer.borderWidth = 2
        midButton.layer.borderWidth = 2
        bottomButton.layer.borderWidth = 2
    }
    
    // MARK: - Custom Methods
    
    private func loadCountries() {
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    private func registerLocalNotifications() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { granted, error in
            if let err = error {
                print("There was an error getting notifications authorization: \(err.localizedDescription)")
            } else {
                
                if granted {
                    self.scheduleDailyNotification()
                }
            }
        }
    }
    
    /// Present the final score in an alertController.
    private func presentEndResults() {
        
        let ac = UIAlertController(title: "End results", message: "Your final score is \(score)", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.score = 0
            self.numberOfQuestions = 0
            self.askQuestion()
        }
        
        ac.addAction(okAction)
        present(ac, animated: true)
        
        return
    }
    
    /// Schedule a local notification 24h after the current execution. 60sec in DEBUG mode.
    private func scheduleDailyNotification() {
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Come back!"
        content.body = "It's been a day since you played, we miss you!"
        content.categoryIdentifier = "dailyReminder"
        
        let timeInterval: TimeInterval
        #if DEBUG
        // Put 60 seconds in DEBUG mode to easily test the local notification
        timeInterval = 60
        #else
        timeInterval = 86400
        #endif
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
            
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    private func PresentRightOrWrongAlert(_ selectedButton: UIButton) {
        
        let title: String
        
        let okAction = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: askQuestion)
        
        if selectedButton.tag == correctAnswer {
            score += 1
            title = "Correct !"
            let message: String = "Your score is \(score)"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
            score -= 1
            score = max(score, 0)

            title = "WROOONG"
            
            let alertController = UIAlertController(title: title, message: "That's the flag of \(countries[selectedButton.tag].capitalized)", preferredStyle: .alert)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
    
    // MARK: - Actions

    @objc private func askQuestion(action: UIAlertAction? = nil) {
        
        guard numberOfQuestions < maxNumberOfQuestions else {
            
            presentEndResults()
            return
        }
        
        numberOfQuestions += 1
        
        numberOfQuestionsLabel.text = "\(numberOfQuestions)/\(maxNumberOfQuestions)"
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].capitalized
        
        topButton.setImage(UIImage(named: countries[0]), for: .normal)
        midButton.setImage(UIImage(named: countries[1]), for: .normal)
        bottomButton.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    @IBAction func flagWasTapped(_ sender: Any) {
        
        guard let selectedButton = sender as? UIButton else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 5) {
            selectedButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        } completion: { finished in
            if finished {
                UIView.animate(withDuration: 0.25) {
                    selectedButton.transform = CGAffineTransform.identity

                } completion: { finished in
                    self.PresentRightOrWrongAlert(selectedButton)
                }
            }
        }
    }
    
    @IBAction private func showScoreTapped(_ sender: Any) {
        
        scoreBarButton.title = "score: \(score)"
    }
}

