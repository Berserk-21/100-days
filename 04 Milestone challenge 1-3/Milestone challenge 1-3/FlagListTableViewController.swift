//
//  ViewController.swift
//  Milestone challenge 1-3
//
//  Created by Berserk on 23/08/2023.
//

import UIKit

class FlagListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var flagsImages: [String] = []

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .lightGray
        loadFlags()
    }

    // MARK: - Methods
    
    private func loadFlags() {
        
        let fileManager = FileManager()
        guard let path = Bundle.main.resourcePath else { return }
        
        let files = try! fileManager.contentsOfDirectory(atPath: path)
        
        files.forEach { file in
            if file.hasSuffix("png") {
                flagsImages.append(file)
            }
        }
    }
    
    // MARK: - UITableView Delegate and Datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flagTableViewCell", for: indexPath)
        
        cell.backgroundColor = .clear
        
        cell.textLabel?.text = flagsImages[indexPath.row]
        
        cell.imageView?.layer.borderWidth = 2.0
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.imageView?.image = UIImage(named: flagsImages[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagsImages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFlag = flagsImages[indexPath.row]
        
        if let flagDetailVC = storyboard?.instantiateViewController(withIdentifier: "FlagDetailViewController") as? FlagDetailViewController {
            flagDetailVC.selectedFlag = selectedFlag
            
            navigationController?.pushViewController(flagDetailVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

