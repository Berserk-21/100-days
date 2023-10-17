//
//  ViewController.swift
//  Project13_instafilter
//
//  Created by Berserk on 16/10/2023.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Properties

    private var currentImage: UIImage?
    private var originalImage: UIImage?

    @IBOutlet private weak var editedImageView: UIImageView!
    @IBOutlet private weak var intensitySlider: UISlider!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    // MARK: - Actions
    
    @objc private func importPicture() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction private func changeFilter() {
        
    }
    
    @IBAction private func save() {
        
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        
    }
    
    // MARK: - UIImage Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage, let originalImage = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = editedImage
        self.originalImage = originalImage
    }
}

