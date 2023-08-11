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
    
    private func displayImage() {
        
        guard let unwrappedSelectedImage = selectedImage else { return }
        
        imageView.image = UIImage(named: unwrappedSelectedImage)
    }
}
