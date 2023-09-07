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
        startGame()
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
    
    private func startGame() {
        
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
}

