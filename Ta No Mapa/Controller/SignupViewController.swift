//
//  SignupViewController.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 14/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import UIKit
import WebKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //https://onthemap-api.udacity.com/v1/session
        
        let url = URL (string: "https://auth.udacity.com/sign-up")
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
    }
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
