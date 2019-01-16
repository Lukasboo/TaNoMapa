//
//  StudentsListViewController.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 01/01/19.
//  Copyright © 2019 Lucas Daniel. All rights reserved.
//

import UIKit

class StudentsTableCell: UITableViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var nameLabelCell: UILabel!
    @IBOutlet weak var urlLabelCell: UILabel!
}

class StudentsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var studentsInformation: ParseStudents?

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var studentsTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsInformation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.studentsTableView != nil {         
            return (self.studentsInformation?.results?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentsTableCell
        
        cell.imageCell.image = cell.imageCell.image!.withRenderingMode(.alwaysTemplate)
        cell.imageCell.tintColor = UIColor.blue
        
        cell.nameLabelCell.text = self.studentsInformation?.results?[indexPath.row].firstName
        cell.urlLabelCell.text = self.studentsInformation?.results?[indexPath.row].mediaURL
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mediaURL = self.studentsInformation?.results?[indexPath.row].mediaURL
            let app = UIApplication.shared
            if let toOpen = mediaURL {
                if let url = URL(string: toOpen) {
                    app.openURL(URL(string: toOpen)!)
                }
        }
    }

    func getStudentsInformation() {
        var result: [[String : AnyObject]]?
        let order = "-updatedAt" as! AnyObject
        
        shadowView.isHidden = false
        activityIndicator.startAnimating()
        
        ParseClient.sharedInstance().taskForGETMethod2("GET") { (success, error) in
            self.studentsInformation = success
            self.studentsTableView.delegate = self
            self.studentsTableView.dataSource = self
            self.studentsTableView.reloadData()
            self.shadowView.isHidden = true
            self.activityIndicator.stopAnimating()
            
        }
    }
    
    @IBAction func update(_ sender: UIBarButtonItem) {
        getStudentsInformation()
    }    
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        OTMClient.sharedInstance().logout { (result) in
            if result {
                Toast.toastMessage("Sucesso ao deslogar")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }  
            } else {
                Toast.toastMessage("Ocorreu um erro ao tentar deslogar. Tente novamente mais tarde!")
            }
        }
    }
    
}
