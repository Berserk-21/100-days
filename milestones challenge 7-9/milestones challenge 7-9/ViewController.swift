//
//  ViewController.swift
//  milestones challenge 7-9
//
//  Created by Berserk on 02/10/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var headView: UIView!
    @IBOutlet private weak var leadingArmView: UIView!
    @IBOutlet private weak var trailingArmView: UIView!
    @IBOutlet private weak var leadingLegView: UIView!
    @IBOutlet private weak var trailingLegView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupHangoutDrawing()
    }

    private func setupHangoutDrawing() {
        
        headView.layer.cornerRadius = headView.frame.width / 2.0
        headView.layer.masksToBounds = true
        
        leadingArmView.transform = leadingArmView.transform.rotated(by: .pi/4)
        trailingArmView.transform = trailingArmView.transform.rotated(by: 3 * .pi/4)
        leadingLegView.transform = leadingLegView.transform.rotated(by: -(.pi/4))
        trailingLegView.transform = trailingLegView.transform.rotated(by: -(3 * .pi/4))
    }

}

