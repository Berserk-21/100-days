//
//  ViewController.swift
//  Project 16 - Capital Cities
//
//  Created by Berserk on 02/11/2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }

}

