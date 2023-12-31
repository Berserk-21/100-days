//
//  ViewController.swift
//  Project15 - Animation
//
//  Created by Berserk on 02/11/2023.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var imageView: UIImageView!
    private var currentAnimation = 0
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView = UIImageView(image: UIImage(named: "penguin")) 
        imageView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        view.addSubview(imageView)
    }

    // MARK: - Actions
    
    @IBAction private func didTap(_ sender: UIButton) {
        
        sender.isHidden = true
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            case 1:
                self.imageView.transform = CGAffineTransform.identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256.0, y: -256.0)
            case 3:
                self.imageView.transform = CGAffineTransform.identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 5:
                self.imageView.transform = CGAffineTransform.identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
            case 7:
                self.imageView.alpha = 1.0
                self.imageView.backgroundColor = UIColor.clear
            default:
                break
            }
        } completion: { finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

