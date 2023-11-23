//
//  ViewController.swift
//  Project25-SelfieShare
//
//  Created by Berserk on 23/11/2023.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    private var images = [UIImage]()
    private var collectionViewInset: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Actions
    
    @objc private func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        images.append(image)
        
        dismiss(animated: true)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            
            let sectionInsets = layout.sectionInset
            let spacingBetweenItems = layout.minimumInteritemSpacing
            let numberOfColumns: Int = 2
            
            let totalSpacing = sectionInsets.left + spacingBetweenItems * (CGFloat(numberOfColumns) - 1) + sectionInsets.right
            
            let adjustedWidth = collectionView.frame.width - totalSpacing
            
            let cellWidth: CGFloat = adjustedWidth / CGFloat(numberOfColumns)
            
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        return CGSize(width: 145.0, height: 145.0)
    }
}

