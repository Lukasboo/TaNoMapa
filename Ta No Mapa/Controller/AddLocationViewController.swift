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
                let mapString = self.locationText.text!
                let mediaURL = self.linkText.text!
                let geocoder = CLGeocoder()
                
                geocoder.geocodeAddressString(mapString, completionHandler: {(placemarks, error) in
                    if let placemark = placemarks?[0] {
                        let latitude = placemark.location!.coordinate.latitude
                        let longitude = placemark.location!.coordinate.longitude
                        ParseClient.sharedInstance().addLocation("POST", firstName: first_name as! String, lastName: last_name as! String, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, result: { (success, error) in
                            DispatchQueue.main.async {
                                self.shadowView.isHidden = true
                                self.activityIndicator.stopAnimating()
                                if error == nil {
                                    Toast.toastMessage("Sucesso ao inserir a localização!")
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    Toast.toastMessage("Ocorreu um erro ao postar a localização!")
                                }
                                
                            }
                        })
                    } else {
                        self.shadowView.isHidden = true
                        self.activityIndicator.stopAnimating()                        
                        Toast.toastMessage(error as! String)
                    }
                })
                
            }
        })
    }
            
}


