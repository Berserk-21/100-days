//
//  WebsitesTableViewController.swift
//  Project #4
//
//  Created by Berserk on 06/09/2023.
//

import UIKit

class WebsitesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var websites: [String] = ["apple", "hackingwithswift", "amazon"]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select a website"
    }
    
    // MARK: - UITableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell", for: indexPath)
        
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedWebsite = websites[indexPath.row]
        
        if let websiteVC = storyboard?.instantiateViewController(withIdentifier: "WebviewViewController") as? WebviewViewController {
            websiteVC.selectedWebsite = selectedWebsite
            navigationController?.pushViewController(websiteVC, animated: true)
        }
    }
}
