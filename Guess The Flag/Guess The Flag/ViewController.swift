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
    
    var countries: [String] = []
    var score: Int = 0
    
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
        
        topButton.setImage(UIImage(named: countries[0]), for: .normal)
        midButton.setImage(UIImage(named: countries[1]), for: .normal)
        bottomButton.setImage(UIImage(named: countries[2]), for: .normal)
    }
}

