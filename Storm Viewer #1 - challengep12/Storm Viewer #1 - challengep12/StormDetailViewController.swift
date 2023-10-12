//
//  StormDetailViewController.swift
//  Storm Viewer #1
//
//  Created by Berserk on 11/08/2023.
//

import UIKit

class StormDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var viewsCountLabel: UILabel!
    
    var selectedImage: String?
    private var viewsCount: Int = 0  {
        didSet {
            viewsCountLabel.text = " \(viewsCount) views "
        }
    }
     
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        displayImage()
        setupShareButton()
        setupViewsCountLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Methods
    
    private func setupTitle() {
    
        title = selectedImage
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupShareButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fastForward, target: self, action: #selector(shareTapped))
    }
    
    private func setupViewsCountLabel() {
        
        viewsCountLabel.backgroundColor = .white
        viewsCountLabel.layer.cornerRadius = 4.0
        
        guard let imageKey = selectedImage else { return }
        
        let userDefault = UserDefaults.standard
        if let savedCount = userDefault.object(forKey: imageKey) as? Int {
            self.viewsCount = savedCount + 1
            userDefault.set(self.viewsCount, forKey: imageKey)
        } else {
            userDefault.set(1, forKey: imageKey)
            self.viewsCount = 1
        }
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
