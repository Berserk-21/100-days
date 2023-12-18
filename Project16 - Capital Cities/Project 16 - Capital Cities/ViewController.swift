//
//  ViewController.swift
//  Project 16 - Capital Cities
//
//  Created by Berserk on 02/11/2023.
//

import UIKit
import MapKit

final class ViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak private var mapView: MKMapView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        addCapitals()
    }
    
    // MARK: - Custom Methods
    
    private func addCapitals() {
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    // MARK: - Actions
    
    @IBAction func changeMapType(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select a new map style", message: nil, preferredStyle: .actionSheet)
        
        let satelliteAction = UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
            self?.mapView.preferredConfiguration = MKImageryMapConfiguration()
        }
        let hybridAction = UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
            self?.mapView.preferredConfiguration = MKHybridMapConfiguration()
        }
        let standardAction = UIAlertAction(title: "Standard", style: UIAlertAction.Style.default) { [weak self] _ in
            self?.mapView.preferredConfiguration = MKStandardMapConfiguration()
        }
        
        alertController.addAction(satelliteAction)
        alertController.addAction(hybridAction)
        alertController.addAction(standardAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let capitalAnnotation = annotation as? Capital else { return nil }
        
        let identifier: String = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: capitalAnnotation, reuseIdentifier: identifier)
            annotationView?.tintColor = .red
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = capitalAnnotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capitalAnnotation = view.annotation as? Capital else { return }
        
        let title = capitalAnnotation.title
        let info = capitalAnnotation.info
        
        let ac = UIAlertController(title: title, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "see more", style: .default, handler: { [weak self] _ in
            
            self?.performSegue(withIdentifier: "showWebView", sender: title)
        }))
        present(ac, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? WebViewController, let capitalTitle = sender as? String {
            nextVC.capitalTitle = capitalTitle
        }
    }
    
}

