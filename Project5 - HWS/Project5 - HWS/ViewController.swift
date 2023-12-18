//
//  ViewController.swift
//  Project5 - HWS
//
//  Created by Berserk on 07/09/2023.
//

import UIKit

final class ViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var allWords = [String]()
    private var usedWords = [String]()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadWords()
        startGame()
        setupNavBar()
    }

    // MARK: - Setup Layout
    
    private func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    }
    
    // MARK: - Helper Methods

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
    
    private func submit(_ answer: String) {
        
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isNew(word: lowerAnswer) {
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(lowerAnswer, at: 0)
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        
                        return
                    } else {
                        errorTitle = "Word not recognised"
                        errorMessage = "You can't just make them up you know!"
                    }
                } else {
                    errorTitle = "Word used already"
                    errorMessage = "Be more original"
                }
            } else {
                guard let title = title?.lowercased() else { return }
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title)"
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "Be smarter, try a different word than the one prompted"
        }
        
        showErrorMessage(title: errorTitle, message: errorMessage)
    }
    
    private func isPossible(word: String) -> Bool {
        
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isNew(word: String) -> Bool {
        return word != title
    }
    
    
    private func isReal(word: String) -> Bool {
        
        guard word.count > 2 else { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
                
        return misspelledRange.location == NSNotFound
    }
    
    private func showErrorMessage(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(ac, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func startGame() {

        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc private func promptForAnswer() {
        
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
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

