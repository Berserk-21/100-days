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

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        guard let url = URL(string: urlString) else { return }
        
        if let data = try? Data(contentsOf: url) {
            self.parse(json: data)
        }
    }
    
    // MARK: - Methods
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        } else {
            print("there was an error decoding")
        }
    }

    // MARK: - UITableViewController DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
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
