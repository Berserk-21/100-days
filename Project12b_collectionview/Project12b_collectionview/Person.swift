//
//  Person.swift
//  Project10_collectionview
//
//  Created by Berserk on 05/10/2023.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
