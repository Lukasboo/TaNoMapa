//
//  AddLocationViewController.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 08/01/19.
//  Copyright © 2019 Lucas Daniel. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var linkText: UITextField!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        shadowView.isHidden = true
        activityIndicator.stopAnimating()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        shadowView.isHidden = false
        activityIndicator.startAnimating()
        
        
        OTMClient.sharedInstance().getUserData("GET", result: { (success, error) in
            if error == nil {
                print((success!["first_name"]!)!)
                let first_name = (success!["first_name"]!)!
                print((success!["last_name"]!)!)
                let last_name = (success!["last_name"]!)!
                let geocoder = CLGeocoder()                
                let mapString = self.locationText.text!
                let mediaURL = self.linkText.text!
                                
                geocoder.geocodeAddressString(mapString, completionHandler: {(placemarks, error) in
                    if let placemark = placemarks?[0] {
                        let latitude = placemark.location!.coordinate.latitude
                        let longitude = placemark.location!.coordinate.longitude
                        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlaceLocationViewController") as! PlaceLocationViewController
                        
                        newViewController.mapString = mapString
                        newViewController.first_name = first_name as! String
                        newViewController.last_name = last_name as! String
                        newViewController.mediaURL = mediaURL
                        newViewController.latitude = latitude
                        newViewController.longitude = longitude
                        self.present(newViewController, animated: true, completion: nil)
                    } else {
                        self.shadowView.isHidden = true
                        self.activityIndicator.stopAnimating()
                        Toast.toastMessage("\(error!.localizedDescription)")
                    }
                })
                
            }
        })
    }
            
}


