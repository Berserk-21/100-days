//
//  ViewController.swift
//  Milestone challenge 1-3
//
//  Created by Berserk on 23/08/2023.
//

import UIKit

class FlagListTableViewController: UITableViewController {
    
    private var flagsImages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .lightGray
        loadFlags()
    }

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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flagTableViewCell", for: indexPath)
        
        cell.backgroundColor = .clear
                
        cell.textLabel?.text = flagsImages[indexPath.row]
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
            
        }
        
    }
}

