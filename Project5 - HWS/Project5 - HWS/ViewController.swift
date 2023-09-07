//
//  ViewController.swift
//  Project5 - HWS
//
//  Created by Berserk on 07/09/2023.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var allWords = [String]()
    private var usedWords = [String]()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadWords()
    }

    // MARK: - Methods

    private func loadWords() {
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            print("startWordsUrl: ",startWordsUrl)
            
            do {
                let startWords = try String(contentsOf: startWordsUrl)
                allWords = startWords.components(separatedBy: "\n")
            } catch {
                print("There was an error converting start.txt to words")
            }
        }
    }
}

