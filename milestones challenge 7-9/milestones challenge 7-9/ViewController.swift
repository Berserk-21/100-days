//
//  ViewController.swift
//  milestones challenge 7-9
//
//  Created by Berserk on 02/10/2023.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties

    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var headView: UIView!
    @IBOutlet private weak var leadingArmView: UIView!
    @IBOutlet private weak var trailingArmView: UIView!
    @IBOutlet private weak var leadingLegView: UIView!
    @IBOutlet private weak var trailingLegView: UIView!
    @IBOutlet private weak var bodyView: UIView!
    @IBOutlet private weak var neckRopeView: UIView!
    
    private var drawingViews: [UIView] = []
    
    private var wordsToFind: [String] = []
    private var result: String = ""
    private var usedLetters: [String] = []
    
    private var guessesLeft: Int = 7 {
        didSet {
            updateGuessesLeft()
    }}
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadWords()
        setupLetters()
    }
    
    // MARK: - Setup Layout

    private func setupLayout() {
        
        headView.layer.cornerRadius = headView.frame.width / 2.0
        headView.layer.masksToBounds = true
        
        scoreLabel.text = "\(guessesLeft) attempts left"
        
        leadingArmView.transform = leadingArmView.transform.rotated(by: .pi/4)
        trailingArmView.transform = trailingArmView.transform.rotated(by: 3 * .pi/4)
        leadingLegView.transform = leadingLegView.transform.rotated(by: -(.pi/4))
        trailingLegView.transform = trailingLegView.transform.rotated(by: -(3 * .pi/4))
        
        drawingViews.append(neckRopeView)
        drawingViews.append(headView)
        drawingViews.append(bodyView)
        drawingViews.append(leadingArmView)
        drawingViews.append(trailingArmView)
        drawingViews.append(leadingLegView)
        drawingViews.append(trailingLegView)
        
        drawingViews.forEach({ $0.alpha = 0 })
    }
    
    private func loadWords() {
        
        guard let fileUrl = Bundle.main.url(forResource: "words_list", withExtension: "txt") else {
            
            let ac = UIAlertController(title: "Start error", message: "No words found, the game can't start", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            self.present(ac, animated: true)
            return
        }
        
        do {
            let file = try String(contentsOf: fileUrl)
           
            let components = file.components(separatedBy: "\n")
            
            components.forEach { component in
                wordsToFind.append(component)
            }
            
        } catch let error {
            print("There was an error loading words: \(error.localizedDescription)")
        }
    }
    
    private func setupLetters() {
        
        guard let randomWord = wordsToFind.randomElement() else { return }
        result = randomWord
        
        #if DEBUG
        print("word to guess: \(randomWord)")
        #endif
        
        if let existingStackView = view.subviews.first(where: { $0 is UIStackView }) {
            existingStackView.removeFromSuperview()
        }
        
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        stackView.distribution = .equalCentering
        view.addSubview(stackView)
        
        for letter in randomWord {
            let l = UILabel()
            l.font = UIFont.systemFont(ofSize: 32.0, weight: .semibold)
            l.text = String(letter)
            l.textColor = UIColor.clear
            stackView.addArrangedSubview(l)
            
            let liner = UIView()
            
            liner.backgroundColor = .black
            liner.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(liner)
            liner.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
            liner.centerXAnchor.constraint(equalTo: l.centerXAnchor).isActive = true
            liner.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
            liner.topAnchor.constraint(equalTo: l.bottomAnchor, constant: 2.0).isActive = true
        }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -12.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0).isActive = true
    }
    
    // MARK: - Methods
    
    private func checkLetter(for letter: String
    ) {
            
        if usedLetters.contains(letter) {
            
            guessesLeft -= 1
            
            if guessesLeft > 0 {
                
                let ac = UIAlertController(title: "Letter already used", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                self.present(ac, animated: true)
            }
            
        } else {
            usedLetters.append(letter)
            
            if result.contains(letter) {
                if let stackView = view.subviews.first(where: { $0 is UIStackView }) {
                    
                    stackView.subviews.forEach { subview in
                        
                        if let label = subview as? UILabel, let letterToFind = label.text {
                            
                            if letter == letterToFind {
                                label.textColor = .black
                            }
                        }
                    }
                }
            } else {
                guessesLeft -= 1
            }
        }
                
        if guessesLeft == 0 {
            let ac = UIAlertController(title: "YOU LOSE!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            self.present(ac, animated: true)
        }
        
        if usedLetters.count == result.count {
            let ac = UIAlertController(title: "YOU WON!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.setupLetters()
            }))
            self.present(ac, animated: true)
        }
    }
    
    private func updateGuessesLeft() {
        
        scoreLabel.text = "\(guessesLeft) attempts left"
        if let viewToShow = drawingViews.first(where: { $0.alpha == 0.0 }) {
            viewToShow.alpha = 1.0
        }
    }

    // MARK: - Actions
    
    @IBAction func PlayButton(_ sender: Any) {
        
        let ac = UIAlertController(title: "Enter a letter", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addTextField { tf in
            tf.delegate = self
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))

        ac.addAction(UIAlertAction(title: "Guess", style: .default, handler: { _ in
            if let tf = ac.textFields?.first, let letter = tf.text {
                
                if letter.count == 1 {
                    self.checkLetter(for: letter)
                }
            }
        }))
        
        present(ac, animated: true)
    }
    
    // MARK: - UITextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard range.location == 0 else { return false }
        
        return true
    }
}

