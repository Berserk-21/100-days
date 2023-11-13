//
//  ViewController.swift
//  Project22-Beacon
//
//  Created by Berserk on 13/11/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var distanceReadingLabel: UILabel!
    var locationManager: CLLocationManager?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    // MARK: - Methods
    
    private func startScanning() {
        
        let major: UInt16 = 123
        let minor: UInt16 = 456
        
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: "MyBeacon23045832")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor))
    }
    
    private func update(distance: CLProximity) {
        UIView.animate(withDuration: 1.0) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReadingLabel.text = "FAR"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReadingLabel.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReadingLabel.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReadingLabel.text = "UNKNOWN"
            }
        }
    }
    
    // MARK: - CLLocationManager Delegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}

