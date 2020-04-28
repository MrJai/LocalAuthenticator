//
//  ViewController.swift
//  LocalAuthenticator
//
//  Created by MrJai on 04/28/2020.
//  Copyright (c) 2020 MrJai. All rights reserved.
//

import UIKit

// Step1: Don't forget to import POD
import LocalAuthenticator

class ViewController: UIViewController {

    @IBOutlet weak var authenticatorType: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LocalAuthenticator.localAuthenticationConfigured() {
            let deviceType = !LocalAuthenticator.faceIDAvailable() ? "Face" : "Touch"
            authenticatorType.image = UIImage(named: "\(deviceType.lowercased())IdIcon")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

