//
//  ViewController.swift
//  Project 1 - Storm Viewer
//
//  Created by Berserk on 11/08/2023.
//

import UIKit

final class StormTableViewController: UITableViewController {

    // MARK: - Properties
    
    private var images = [String]()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTitle()
        loadImages()
    }
    
    // MARK: - Setup Layout
    
    private func setupTitle() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Storm Viewer"
        tabBarItem.title = "TableView layout"
    }
    
    // MARK: - Custom Methods
    
    private func loadImages() {
        
        DispatchQueue.global(qos: .background).async {
            self.addImages()
        }
    }
    
    private func addImages() {
        
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath else { return }
        
        let files = try! fileManager.contentsOfDirectory(atPath: path)
        
        for file in files {
            if file.hasPrefix("nssl") {
                images.append(file)
            }
        }
        
        images.sort()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StormCell", for: indexPath)
        
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        cell.textLabel?.text = images[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let stormDetailVC = storyboard?.instantiateViewController(withIdentifier: "StormDetailViewController") as? StormDetailViewController else { return }

        stormDetailVC.selectedImage = images[indexPath.row]

        self.navigationController?.pushViewController(stormDetailVC, animated: true)
    }
}

