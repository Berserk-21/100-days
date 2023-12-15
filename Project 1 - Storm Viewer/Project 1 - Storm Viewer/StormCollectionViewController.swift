//
//  StormCollectionViewController.swift
//  Project 1 - Storm Viewer
//
//  Created by Berserk on 06/10/2023.
//

import UIKit

final class StormCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private var stormImages: [String] = []
    private let minimumLineSpacing: CGFloat = 4.0
    private let minimumInterItemSpacing: CGFloat = 4.0
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        loadImages()
    }
    
    // MARK: - Setup Layout
    
    private func setupTitle() {
        
        tabBarItem.title = "CollectionView layout"
    }
    
    // MARK: - Methods
    
    private func loadImages() {
        
        DispatchQueue.global(qos: .background).async {
            self.addImages()
        }
    }
    
    private func addImages() {
        
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath else { return }
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            
            files.forEach { file in
                if file.hasPrefix("nssl") {
                    stormImages.append(file)
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch let error {
            print("There was an error getting images from bundle: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StormCollectionViewCell.identifier, for: indexPath) as? StormCollectionViewCell else {
            
            fatalError("Couldn't get a StormCollectionViewCell")
        }
        
        cell.stormImageView.image = UIImage(named: stormImages[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return stormImages.count
    }
    
    // MARK: - UICollectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let stormDetailVC = storyboard?.instantiateViewController(withIdentifier: "StormDetailViewController") as? StormDetailViewController else { return }

        stormDetailVC.selectedImage = stormImages[indexPath.row]

        self.navigationController?.pushViewController(stormDetailVC, animated: true)
    }
    
    // MARK: - UICollectionView Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let nbOfColumns: Int = 2
        
        let interItemSpacings = minimumInterItemSpacing * (CGFloat(nbOfColumns - 1))

        let availableWidth: CGFloat = collectionView.frame.width - interItemSpacings
        
        let itemWidth: CGFloat = availableWidth / CGFloat(nbOfColumns)
        
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
}
