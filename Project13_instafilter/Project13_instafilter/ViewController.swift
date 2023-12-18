//
//  ViewController.swift
//  Project13_instafilter
//
//  Created by Berserk on 16/10/2023.
//

import UIKit
import CoreImage

final class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Properties

    private var currentImage: UIImage?
    private var originalImage: UIImage?
    
    private var context: CIContext!
    private var currentFilter: CIFilter!

    @IBOutlet private weak var editedImageView: UIImageView!
    @IBOutlet private weak var changeFilterButton: UIButton!
    
    @IBOutlet private weak var intensitySlider: UISlider!
    @IBOutlet private weak var intensityLabel: UILabel!
    @IBOutlet private weak var radiusSlider: UISlider!
    @IBOutlet private weak var radiusLabel: UILabel!
    
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
        changeFilterButton.setTitle("CISepiaTone", for: .normal)
    }
    
    // MARK: - Custom Methods
    
    private func applyProcessing() {
        
        guard let unwrappedCurrentImage = currentImage else { return }
        
        let inputKeys = currentFilter.inputKeys
        
        intensitySlider.isEnabled = false
        radiusSlider.isEnabled = false
        
        if inputKeys.contains(kCIInputIntensityKey) {
            intensitySlider.isEnabled = true
            intensityLabel.text = "Intensity:"
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            radiusSlider.isEnabled = true
            currentFilter.setValue(radiusSlider.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            intensitySlider.isEnabled = true
            intensityLabel.text = "Scale:"
            currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: unwrappedCurrentImage.size.width / 2.0, y: unwrappedCurrentImage.size.height / 2.0), forKey: kCIInputCenterKey)
        }
        
        if let cgImage = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            
            editedImageView.alpha = 0.0
            editedImageView.image = processedImage

            UIView.animate(withDuration: 20) {
                self.editedImageView.alpha = 1.0
            }
            currentImage = processedImage
        }
    }
    
    private func setFilter(action: UIAlertAction) {
        
        guard let unwrappedCurrentImage = currentImage else {
            self.presentNoImageToFilterAlert()
            return
        }
        
        guard let actionTitle = action.title else { return }
        
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: unwrappedCurrentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    private func presentNoImageToFilterAlert() {
        
        let ac = UIAlertController(title: "No photo", message: "Please import a photo first!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func importPicture() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction private func changeFilter() {
        
        guard currentImage != nil else {
            self.presentNoImageToFilterAlert()
            return
        }
        
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    @IBAction private func save() {
        
        guard let unwrappedCurrentImage = currentImage else {
            let ac = UIAlertController(title: "Can't save", message: "There is no image to save to library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(unwrappedCurrentImage, self, #selector(image(_: didFinishSavingWithError: contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let err = error {
            let ac = UIAlertController(title: "Save error", message: err.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved to library !", message: nil, preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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

