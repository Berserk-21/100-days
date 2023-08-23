//
//  FlagDetailViewController.swift
//  Milestone challenge 1-3
//
//  Created by Berserk on 23/08/2023.
//

import UIKit

class FlagDetailViewController: UIViewController {

    // MARK: - Properties
    
    var selectedFlag: String?

    @IBOutlet private var flagImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        setupFlagImage()
    }
    
    // MARK: - Methods
    
    private func setupFlagImage() {
        
        if let unwrappedSelectedFlag = selectedFlag {
            flagImageView.image = UIImage(named: unwrappedSelectedFlag)
        }
    }
}
