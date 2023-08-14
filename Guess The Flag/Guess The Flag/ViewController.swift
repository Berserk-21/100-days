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

    private func askQuestion() {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].capitalized
        
        topButton.setImage(UIImage(named: countries[0]), for: .normal)
        midButton.setImage(UIImage(named: countries[1]), for: .normal)
        bottomButton.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func flagWasTapped(_ sender: Any) {
        
        if let selectedButton = sender as? UIButton {
            
            if selectedButton.tag == correctAnswer {
                score += 1
            } else {
                score -= 1
            }
            
            scoreLabel.text = "\(score)"
            
            switch selectedButton.tag {
            case 0:
                print("The answer is \(countries[0])")
            case 1:
                print("The answer is \(countries[1])")
            case 2:
                print("The answer is \(countries[2])")
            default:
                break
            }
        }
    }
}

