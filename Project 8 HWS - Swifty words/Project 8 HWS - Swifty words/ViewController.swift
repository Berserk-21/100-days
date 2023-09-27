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
    private var letterButtons = [UIButton]()
    
    private var buttonWidth: CGFloat = 150.0
    private var buttonHeight: CGFloat = 80.0
        
    private var activatedButtons = [UIButton]()
    private var selectedButtons = [UIButton]()
    private var solutions = [String]()
    private var clues = [String]()
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
        }
    }
    private var level = 1
    private var maxLevel = 2
    private var maxLevelScore = 7
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        setupLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
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
        cluesLabel.numberOfLines = 0
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.font = UIFont.systemFont(ofSize: 24.0)
        answersLabel.text = "ANSWERS"
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
        buttonsContainerView.layer.borderWidth = 2.0
        buttonsContainerView.layer.borderColor = UIColor.lightGray.cgColor
        buttonsContainerView.layer.cornerRadius = 4.0
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
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
                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let xPos = CGFloat(i) * buttonWidth
                let YPos = CGFloat(j) * buttonHeight
                
                button.frame = CGRect(x: xPos, y: YPos, width: buttonWidth, height: buttonHeight)
                buttonsContainerView.addSubview(button)
                letterButtons.append(button)
            }
        }
    }
    
    private func loadLevel() {
        
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ":")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1).\(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters \n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
        
    // MARK: - Actions
    
    @objc private func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswerTextField.text = currentAnswerTextField.text?.appending(buttonTitle)
        selectedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc private func submitTapped(_ sender: UIButton) {
        
        guard let answerText = currentAnswerTextField.text else { return }
        
        if let correctSolutionIndex = solutions.firstIndex(of: answerText) {
            
            activatedButtons.append(contentsOf: selectedButtons)
            selectedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            
            splitAnswers?[correctSolutionIndex] = answerText
            
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswerTextField.text = ""
            score += 1
        } else {
            
            selectedButtons.forEach({$0.isHidden = false})
            selectedButtons.removeAll()
            
            let ac = UIAlertController(title: "Wrong!", message: "\(answerText) is not a good answer.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.currentAnswerTextField.text = ""
                self.selectedButtons.forEach({$0.isHidden = false})
                self.selectedButtons.removeAll()
            }))
            present(ac, animated: true)
            return
        }
        
        // End the game
        if score == maxLevelScore * maxLevel {
            let ac = UIAlertController(title: "THE END!", message: "Congratulations, you have won the game!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        // Go to next level
        if score == maxLevelScore {
            let ac = UIAlertController(title: "Well done!", message: "Are you ready for next level ?", preferredStyle: UIAlertController.Style.actionSheet)
            ac.addAction(UIAlertAction(title: "No way", style: UIAlertAction.Style.destructive))
            ac.addAction(UIAlertAction(title: "Yes!", style: UIAlertAction.Style.default, handler: levelUp))
            ac.popoverPresentationController?.sourceItem = sender
            
            present(ac, animated: true)
        }
    }
    
    @objc private func clearTapped(_ sender: UIButton) {
        currentAnswerTextField.text = ""
        
        selectedButtons.forEach({$0.isHidden = false})
        
        selectedButtons.removeAll()
    }
    
    @objc private func levelUp(_ :UIAlertAction) {
        
        level += 1
        solutions.removeAll()
        
        loadLevel()
        activatedButtons.forEach( {$0.isHidden = false })
        activatedButtons.removeAll()
    }
}

