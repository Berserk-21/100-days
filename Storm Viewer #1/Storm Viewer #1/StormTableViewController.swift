//
//  ViewController.swift
//  Storm Viewer #1
//
//  Created by Berserk on 11/08/2023.
//

import UIKit

class StormTableViewController: UITableViewController {
    
    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addImages()
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
    }
}

