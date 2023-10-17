//
//  ViewController.swift
//  Project13_instafilter
//
//  Created by Berserk on 16/10/2023.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Properties

    private var currentImage: UIImage?
    private var originalImage: UIImage?
    
    private var context: CIContext!
    private var currentFilter: CIFilter!

    @IBOutlet private weak var editedImageView: UIImageView!
    @IBOutlet private weak var intensitySlider: UISlider!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        setupFilter()
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    private func setupFilter() {
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    private func applyProcessing() {
        
        guard let image = currentFilter.outputImage else { return }
        currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            editedImageView.image = processedImage
        }
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
        applyProcessing()
    }
    
    // MARK: - UIImage Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage, let originalImage = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = editedImage
        self.originalImage = originalImage
        
        let beginImage = CIImage(image: editedImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
}

