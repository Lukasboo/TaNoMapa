//
//  ViewController.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 13/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shadowView.isHidden = true
        activityIndicator.isHidden = true
    }
        
    @IBAction func loginPressed(_ sender: UIButton) {
        shadowView.isHidden = false
        activityIndicator.startAnimating()
        if !(emailText.text?.isEmpty)! && !(passwordText.text?.isEmpty)! {
            //if Functions.isInternetAvailable() {
                OTMClient.sharedInstance().login("POST", username: emailText.text!, password: passwordText.text!) { (success, error) in
                
                    if error != nil {
                        DispatchQueue.main.async {
                            Toast.toastMessage((error?.localizedDescription)!)
                            /*self.shadowView.isHidden = true
                            self.activityIndicator.stopAnimating()*/
                        }
                    } else {
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyboard.instantiateViewController(withIdentifier: "MapTabBarController")
                            self.present(newViewController, animated: true, completion: nil)
                        }
                    }
                    DispatchQueue.main.async {
                        self.shadowView.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                }
            /*} else {
                self.shadowView.isHidden = true
                Toast.toastMessage("Sem conexão com a Internet!")
                self.activityIndicator.stopAnimating()
            }*/
        } else {
            self.shadowView.isHidden = true
            self.activityIndicator.stopAnimating()
            Toast.toastMessage("Campo inválido!!")
            
        }
    }
        
    @IBAction func signupPressed(_ sender: UIButton) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "SignupViewController")
        present(newViewController!, animated: true, completion: nil)
    }
}

