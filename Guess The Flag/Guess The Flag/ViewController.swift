//
//  ViewController.swift
//  Guess The Flag
//
//  Created by Berserk on 14/08/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var topButton: UIButton!
    @IBOutlet private weak var midButton: UIButton!
    @IBOutlet private weak var bottomButton: UIButton!
    
    var countries: [String] = []
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .lightGray
    }


}

