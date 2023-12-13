//
//  ViewController.swift
//  Project31-Multibrowser
//
//  Created by Berserk on 13/12/2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet private weak var addressBar: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDefaultTitle()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButton))
        
        navigationItem.rightBarButtonItems = [deleteButton, addButton]
    }

    private func setDefaultTitle() {
        
        title = "Multibrowser"
    }
    
    @objc private func didTapAddButton() {
        
        
    }
    
    @objc private func didTapDeleteButton() {
        
        
    }
}

