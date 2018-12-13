//
//  ViewController.swift
//  LocalAuthenticator
//
//  Created by MrJai on 11/13/2018.
//  Copyright (c) 2018 MrJai. All rights reserved.
//

import UIKit
import LocalAuthenticator

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    var deviceType: String = "Touch"
    
    @IBAction func actionOnSubmitBtn(_ sender: UIButton) {
        if self.usernameField.text?.count == 0 ||
            self.passwordField.text?.count == 0
        {
            let alertController = UIAlertController(title: "Warning", message: "Fields can not be left empty", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: {
            })
        }
        
        let loginCreds = ["username": self.usernameField.text,
                          "password": self.passwordField.text]
        if  LocalAuthenticator.saveCredentials(credentials: loginCreds as! Dictionary<String, String>) {
            let alertController = UIAlertController(title: self.deviceType + " ID", message: "Do you want to use "+self.deviceType+" for auto login? ", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                LocalAuthenticator.validateLocalAuthentication { (success, msg) in
                    
                    let loginCredentials = LocalAuthenticator.getSavedCredentials();
                    self.usernameField.text = loginCredentials["username"]
                    self.passwordField.text = loginCredentials["password"]
                    var alertController:UIAlertController
                    if success {
                        alertController = UIAlertController(title: "Success", message: "Authentication successful", preferredStyle: .alert)
                        print("Authentication successful")
                        self.resumeLogin()
                    }
                    else
                    {
                        alertController = UIAlertController(title: "Failure", message: "Authentication Failed with msg: "+msg, preferredStyle: .alert)
                        print("Authentication Failed with msg: "+msg)
                    }
                    let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                    })
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: {
                    })
                }
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                self.resumeLogin()
            })
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: {
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LocalAuthenticator.faceIDAvailable() {
            self.deviceType = "Face"
        }
        
        if  LocalAuthenticator.getSavedCredentials().count > 0 &&
            LocalAuthenticator.localAuthenticationConfigured() {
            LocalAuthenticator.validateLocalAuthentication { (success, msg) in
                var alertController:UIAlertController
                if success {
                    alertController = UIAlertController(title: "Success", message: "Authentication successful", preferredStyle: .alert)
                    print("Authentication successful")
                    self.resumeLogin()
                }
                else
                {
                    alertController = UIAlertController(title: "Failure", message: "Authentication Failed with msg: "+msg, preferredStyle: .alert)
                    print("Authentication Failed with msg: "+msg)
                }
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: {
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.passwordField) &&
            self.usernameField.text?.count ?? 0 > 0
        {
            self.actionOnSubmitBtn(self.submitBtn)
        }
        return false
    }
    
    func resumeLogin() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "dummyView")
        self.navigationController?.pushViewController((viewController ?? nil)!, animated: true)
    }
}

