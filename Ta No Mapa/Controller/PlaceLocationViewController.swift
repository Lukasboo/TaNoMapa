//
//  PlaceLocationViewController.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 16/01/19.
//  Copyright © 2019 Lucas Daniel. All rights reserved.
//

import UIKit
import MapKit

class PlaceLocationViewController: UIViewController, MKMapViewDelegate {

    var mapString: String?
    var first_name: String?
    var last_name: String?
    var mediaURL: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMap()
    }
    
    func setupMap() {
        var coordinate: CLLocationCoordinate2D?
        if latitude is NSNull || longitude is NSNull {
            print("Latitude ou Longitude com valor inválido!")
        } else if latitude != nil && longitude != nil {
            coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
        let annotation = MKPointAnnotation()
        if coordinate != nil {
            annotation.coordinate = coordinate!
            if first_name !=  nil && last_name != nil {
                annotation.title = "\(first_name!) \(last_name!)"
            }
            annotation.subtitle = mediaURL
        }
        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let urlToOpen = view.annotation?.subtitle {
            if control == view.rightCalloutAccessoryView {
                let app = UIApplication.shared
                if let toOpen = view.annotation?.subtitle! {
                    app.openURL(URL(string: toOpen)!)
                }
            }
        }
    }
    
    func insertLocation() {
        self.shadowView.isHidden = false
        self.activityIndicator.startAnimating()
        ParseClient.sharedInstance().addLocation("POST", firstName: first_name as! String, lastName: last_name as! String, mapString: mapString!, mediaURL: mediaURL!, latitude: latitude!, longitude: longitude!, result: { (success, error) in
            DispatchQueue.main.async {
                self.shadowView.isHidden = true
                self.activityIndicator.stopAnimating()
                if error == nil {
                    Toast.toastMessage("Sucesso ao inserir a localização!")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyboard.instantiateViewController(withIdentifier: "MapTabBarController")
                    self.present(newViewController, animated: true, completion: {
                        Toast.toastMessage("Sucesso ao inserir a localização!")
                    })
                } else {
                    Toast.toastMessage("Ocorreu um erro ao postar a localização!")
                }                
            }
        })
        self.shadowView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
 
    @IBAction func addLocation(_ sender: UIButton) {
        insertLocation()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
