//
//  ViewController.swift
//  Guess The Flag
//
//  Created by Berserk on 14/08/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var topButton: UIButton!
    @IBOutlet private weak var midButton: UIButton!
    @IBOutlet private weak var bottomButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    private var countries: [String] = []
    private var score: Int = 0
    private var correctAnswer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupCountries()
        askQuestion()
    }

    private func setupUI() {
     
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
    
    private func setupCountries() {
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }

    @objc private func askQuestion(action: UIAlertAction? = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].capitalized
        
        topButton.setImage(UIImage(named: countries[0]), for: .normal)
        midButton.setImage(UIImage(named: countries[1]), for: .normal)
        bottomButton.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func flagWasTapped(_ sender: Any) {
        
        guard let selectedButton = sender as? UIButton else { return }
        
        let title: String
        
        if selectedButton.tag == correctAnswer {
            score += 1
            title = "Correct !"
        } else {
            score -= 1
            title = "WROOONG"
        }
        
        scoreLabel.text = "\(score)"
        
        let message: String = "Your score is \(score)"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: askQuestion)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

