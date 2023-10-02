//
//  ViewController.swift
//  milestones challenge 7-9
//
//  Created by Berserk on 02/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var headView: UIView!
    @IBOutlet private weak var leadingArmView: UIView!
    @IBOutlet private weak var trailingArmView: UIView!
    @IBOutlet private weak var leadingLegView: UIView!
    @IBOutlet private weak var trailingLegView: UIView!
    
    private var wordsToFind: [String] = []
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupHangoutDrawing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLetters()
    }
    
    // MARK: - Methods

    private func setupHangoutDrawing() {
        
        headView.layer.cornerRadius = headView.frame.width / 2.0
        headView.layer.masksToBounds = true
        
        leadingArmView.transform = leadingArmView.transform.rotated(by: .pi/4)
        trailingArmView.transform = trailingArmView.transform.rotated(by: 3 * .pi/4)
        leadingLegView.transform = leadingLegView.transform.rotated(by: -(.pi/4))
        trailingLegView.transform = trailingLegView.transform.rotated(by: -(3 * .pi/4))
    }
    
    private func setupLetters() {
        
        if let fileUrl = Bundle.main.url(forResource: "words_list", withExtension: "txt"),
            let file = try? String(contentsOf: fileUrl) {
            
            let components = file.components(separatedBy: "\n")
            
            components.forEach { component in
                wordsToFind.append(component)
            }
            
            guard let randomWord = wordsToFind.randomElement() else { return }
            
            let nbOfLetters: Int = randomWord.count
            
            let stackView: UIStackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 12.0
            stackView.distribution = .equalSpacing
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

        } else {
            let ac = UIAlertController(title: "Start error", message: "No words found, the game can't start", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))

            self.present(ac, animated: true)
        }
    }

}

