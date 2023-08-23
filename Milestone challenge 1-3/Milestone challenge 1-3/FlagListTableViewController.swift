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
        print(flagsImages)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flagTableViewCell", for: indexPath)
        
        cell.imageView?.image = UIImage(named: flagsImages[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagsImages.count
    }
}

