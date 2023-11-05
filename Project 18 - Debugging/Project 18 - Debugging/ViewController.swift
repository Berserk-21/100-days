//
//  ViewController.swift
//  Project 18 - Debugging
//
//  Created by Berserk on 05/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        testPrints()
//        testAssertions()
        
        for i in 0...100 {
            print("number \(i)")
        }
    }
    
    // MARK: - Methods
    
    private func testPrints() {
        
        print(1, 2, 3, separator: "-")
        print(1, 2, 3, terminator: "_end")
    }
    
    private func testAssertions() {
        assert(1 == 2, "Math failure")
        
        assert(returnFalse() == true, "the returnFalse method returned false")
    }
    
    private func returnFalse() -> Bool {
        
        return false
    }

}

