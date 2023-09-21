//
//  ViewController.swift
//  Project 8 HWS - Swifty words
//
//  Created by Berserk on 21/09/2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cluesLabel: UILabel!
    private var answersLabel: UILabel!
    private var currentAnswerTextField: UITextField!
    private var scoreLabel: UILabel!
    private var lettersButtons = [UIButton]()
    
    private var buttonWidth: CGFloat = 150.0
    private var buttonHeight: CGFloat = 80.0
    
    private var letterButtonsContainer: [UIButton] = []
    
    private var activatedButtons = [UIButton]()
    private var solutions = [String]()
    
    private var score = 0
    private var level = 1
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        setupLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    
    private func setupLabels() {
        
        scoreLabel = UILabel()
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0.0).isActive = true
        
        cluesLabel = UILabel()
        cluesLabel.font = UIFont.systemFont(ofSize: 24.0)
        cluesLabel.text = "CLUES"
        cluesLabel.backgroundColor = .red
        cluesLabel.numberOfLines = 0
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.font = UIFont.systemFont(ofSize: 24.0)
        answersLabel.text = "ANSWERS"
        answersLabel.backgroundColor = .blue
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answersLabel)
        
        cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 0.0).isActive = true
        cluesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100.0).isActive = true
        cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100).isActive = true
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 0.0).isActive = true
        answersLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100.0).isActive = true
        answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100.0).isActive = true
        answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor, multiplier: 1.0).isActive = true
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswerTextField = UITextField()
        currentAnswerTextField.placeholder = "Tap letters to guess"
        currentAnswerTextField.textAlignment = .center
        currentAnswerTextField.font = UIFont.systemFont(ofSize: 44.0)
        currentAnswerTextField.isUserInteractionEnabled = false
        currentAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentAnswerTextField)
        
        currentAnswerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentAnswerTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0.0).isActive = true
        currentAnswerTextField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20.0).isActive = true
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: currentAnswerTextField.bottomAnchor, constant: 0.0).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100.0).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor, constant: 0.0).isActive = true
        clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100.0).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        let buttonsContainerView = UIView()
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainerView.backgroundColor = .green
        view.addSubview(buttonsContainerView)
        buttonsContainerView.widthAnchor.constraint(equalToConstant: 750.0).isActive = true
        buttonsContainerView.heightAnchor.constraint(equalToConstant: 320.0).isActive = true
        buttonsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsContainerView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20.0).isActive = true
        buttonsContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20.0).isActive = true
        
        // Fill the buttonsContainerView without auto-layout
        for i in 0..<5 {
            for j in 0..<4 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36.0)
                button.setTitle("WWW", for: .normal)
                button.backgroundColor = [UIColor.red, UIColor.purple, UIColor.gray, UIColor.yellow].randomElement()
                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let xPos = CGFloat(i) * buttonWidth
                let YPos = CGFloat(j) * buttonHeight
                
                print("xPos: ",xPos)
                print("YPos: ",YPos)
                
                button.frame = CGRect(x: xPos, y: YPos, width: buttonWidth, height: buttonHeight)
                buttonsContainerView.addSubview(button)
                letterButtonsContainer.append(button)
            }
        }
    }
        
    // MARK: - Actions
    
    @objc private func letterTapped(_ sender: UIButton) {
        
    }
    
    @objc private func submitTapped(_ sender: UIButton) {
        
    }
    
    @objc private func clearTapped(_ sender: UIButton) {
        
    }
}

