//
//  CustomAlertView.swift
//  Ta No Mapa
//
//  Created by Lucas Daniel on 14/12/18.
//  Copyright © 2018 Lucas Daniel. All rights reserved.
//

import UIKit

class CustomAlert: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    
    convenience init(title:String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(title:String){
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0 - Screen.screenHeight*4/100, width: dialogViewWidth-16, height: Screen.screenHeight*20/100))
        titleLabel.text = title
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: Screen.screenHeight*0.021)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.darkGray
        dialogView.addSubview(titleLabel)
        
        
        let dialogViewHeight = Screen.screenHeight*12/100
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
}

