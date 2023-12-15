//
//  StormDetailViewController.swift
//  Project 1 - Storm Viewer
//
//  Created by Berserk on 11/08/2023.
//

import UIKit

final class StormDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private var imageView: UIImageView!
    
    var selectedImage: String?
     
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(selectedImage != nil, "There is no selected image to present, please check injection")
        
        setupTitle()
        displayImage()
        setupShareButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Setup Layout
    
    private func setupTitle() {
    
        title = selectedImage
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupShareButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fastForward, target: self, action: #selector(shareTapped))
    }
    
    private func displayImage() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        guard let unwrappedSelectedImage = selectedImage else { return }
        
        imageView.image = UIImage(named: unwrappedSelectedImage)
    }
    
    // MARK: - Actions
    
    @objc private func shareTapped() {
        
        let praiseApp: String = "Check this amazing app my friend: Storm Viewer !"
        
        let ac = UIActivityViewController(activityItems: [praiseApp], applicationActivities: nil)
        
        present(ac, animated: true)
    }
}
