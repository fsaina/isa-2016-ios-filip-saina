//
//  RootViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 04/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

/**
 * Login view controller class. Contains all the necessary logic for
 * handling the login process.
 */
class RootViewController: UIViewController {
    
    // refference to the email text field
    @IBOutlet weak var emailTextField: UITextField!
    
    // refference to the login button field
    @IBOutlet weak var loginButton: UIButton!
    
    // refference password text filed
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
    }
    
    // Touch button handler for the login button
    @IBAction func loginButtonPressed(sender: UIButton) {
        if emailTextField.text != nil{
            print("Email field: " + emailTextField.text!)
        }
        
        if(passwordTextField.text != nil){
            print("Password field: " + passwordTextField.text!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
