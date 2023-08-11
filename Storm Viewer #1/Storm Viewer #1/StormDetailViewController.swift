//
//  StormDetailViewController.swift
//  Storm Viewer #1
//
//  Created by Berserk on 11/08/2023.
//

import UIKit

class StormDetailViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    
    var selectedImage: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    private func displayImage() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        guard let unwrappedSelectedImage = selectedImage else { return }
        
        imageView.image = UIImage(named: unwrappedSelectedImage)
    }
}
