//
//  ViewController.swift
//  project7 HWS - whitehouse petitions
//
//  Created by Berserk on 20/09/2023.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var petitions = [Petition]()
    private var filteredPetitions = [Petition]()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupNavBarItem()
        
        fetchJSON()
    }
    
    // MARK: - Methods
    
    private func setupNavBarItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: UIBarButtonItem.Style.done, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItem.Style.done, target: self, action: #selector(filterPetition))
    }
    
    private func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
            } else {
                self.performSelector(onMainThread: #selector(self.showError), with: nil, waitUntilDone: false)
            }
        }
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc private func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "All data comes from the We The People API of the White House", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(ac, animated: true)
    }
    
    @objc private func filterPetition() {
        
        let ac = UIAlertController(title: "Filter", message: "Enter a keyword to show related petitions", preferredStyle: .alert)
        ac.addTextField()
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            
            if let textField = ac.textFields?.first, let filter = textField.text {
                self.filteredPetitions = self.petitions.filter({ petition in
                    if petition.title.lowercased().contains(filter.lowercased()) {
                        return true
                    } else {
                        return false
                    }
                })
            }
            
            if self.filteredPetitions.count > 0 {
                self.tableView.reloadData()
            }
        }
        
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { action in
            self.filteredPetitions = []
            self.tableView.reloadData()
        }
        
        ac.addAction(resetAction)
        ac.addAction(okAction)

        present(ac, animated: true)
    }

    // MARK: - UITableViewController DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredPetitions.count > 0 {
            return filteredPetitions.count
        }
        
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petitionForIndex: Petition
        
        if filteredPetitions.count > 0 {
            petitionForIndex = filteredPetitions[indexPath.row]
        } else {
            petitionForIndex = petitions[indexPath.row]
        }
        
        cell.textLabel?.text = petitionForIndex.title
        cell.detailTextLabel?.text = petitionForIndex.body
        return cell
    }
    
    // MARK: - UITableViewController Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = petitions[indexPath.row]
        let nextVC = DetailViewController()
        nextVC.detailItem = selectedItem
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
