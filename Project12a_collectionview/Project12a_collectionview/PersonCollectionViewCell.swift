//
//  PersonCollectionViewCell.swift
//  Project10_collectionview
//
//  Created by Berserk on 04/10/2023.
//

import UIKit

final class PersonCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "PersonCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
}
