//
//  ViewController.swift
//  Project15 - Animation
//
//  Created by Berserk on 02/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView = UIImageView(image: UIImage(named: "penguin")) 
        imageView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        view.addSubview(imageView)
    }

    @IBAction private func didTap() {
        
    }
}

