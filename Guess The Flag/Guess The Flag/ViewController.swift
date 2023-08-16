//
//  ViewController.swift
//  Guess The Flag
//
//  Created by Berserk on 14/08/2023.
//

import UIKit

class ViewController: UIViewController {
    
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
        
        setupUI()
        setupCountries()
        askQuestion()
    }

    // MARK: - Methods
    
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
    
    // MARK: - Actions
    
    @IBAction func flagWasTapped(_ sender: Any) {
        
        guard let selectedButton = sender as? UIButton else { return }
        
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
    
    @IBAction private func showScoreTapped(_ sender: Any) {
        
        scoreBarButton.title = "score: \(score)"
    }
}

