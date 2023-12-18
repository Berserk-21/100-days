//
//  ViewController.swift
//  Project22-Beacon
//
//  Created by Berserk on 13/11/2023.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var distanceReadingLabel: UILabel!
    private var locationManager: CLLocationManager?
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLocationManager()
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        view.backgroundColor = .gray
    }
    
    // MARK: - Custom Methods
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func startScanning() {
        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "Apple AirLocate")
        addBeaconRegion(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", major: 123, minor: 456, identifier: "Radius Networks")
        addBeaconRegion(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, identifier: "TwoCanoes")
    }
        
    private func addBeaconRegion(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        let uuid = UUID(uuidString: uuidString)!
        let region = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor), identifier: identifier)
        
        locationManager?.startMonitoring(for: region)
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

