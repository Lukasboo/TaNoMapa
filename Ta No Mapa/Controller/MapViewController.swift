//
//  MapViewController.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 14/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudentsInformation()
    }
    
    func setupMap(locations: ParseStudents) {
        
        var annotations = [MKPointAnnotation]()
        
        for (index, element) in locations.results!.enumerated() {
            var lat: CLLocationDegrees?
            var long:CLLocationDegrees?
            var coordinate: CLLocationCoordinate2D?
            do {
                if let latitude = element.latitude {
                    if latitude is NSNull {
                        print("NSNULL AQUI")
                    } else if latitude != nil  {
                        lat = CLLocationDegrees(latitude as! Double)
                    }
                }
                
                if let longitude = element.longitude {
                    if longitude is NSNull {
                        print("NSNULL AQUI")
                    } else if longitude != nil {
                        long = CLLocationDegrees(longitude as! Double)
                    }
                }
                
                if lat is NSNull || long is NSNull {
                    print("error")
                } else if lat != nil && long != nil {
                    coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                }
                
                let first = element.firstName as? String
                let last = element.lastName as? String
                let mediaURL = element.mediaURL as? String
                
                let annotation = MKPointAnnotation()
                if coordinate != nil {
                    annotation.coordinate = coordinate!
                    if first !=  nil && last != nil {
                        annotation.title = "\(first!) \(last!)"
                    }
                    annotation.subtitle = mediaURL
                }
                
                annotations.append(annotation)
         
            } catch {
                self.shadowView.isHidden = true
                self.activityIndicator.stopAnimating()
                Toast.toastMessage("Ocorreu um erro. Tente mais tarde novamente!")
            }
            self.mapView.addAnnotations(annotations)
            
        }
        shadowView.isHidden = true
        activityIndicator.stopAnimating()
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
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func getStudentsInformation() {
        shadowView.isHidden = false
        activityIndicator.startAnimating()
        var result: [[String : AnyObject]]?
        let order = "-updatedAt" as! AnyObject
        ParseClient.sharedInstance().taskForGETMethod2("GET") { (success, error) in
            if error == nil {
                self.setupMap(locations: success!)
            } else {
                self.shadowView.isHidden = true
                self.activityIndicator.stopAnimating()
                Toast.toastMessage("Ocorreu um erro ao tentar carregar as informações!")
            }
        }
    }
    
    @IBAction func update(_ sender: UIBarButtonItem) {
        getStudentsInformation()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        OTMClient.sharedInstance().logout { (result) in
            if result {
                Toast.toastMessage("Sucesso ao deslogar")
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController")
                self.present(newViewController!, animated: true, completion: nil)
            } else {
                Toast.toastMessage("Ocorreu um erro ao tentar deslogar. Tente novamente mais tarde!")
            }
        }
    }
}
