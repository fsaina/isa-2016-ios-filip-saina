//
//  RegisterViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 10/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

/**
 * Login view controller class. Contains all the necessary logic for
 * handling the login process.
 */
class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var navigationViewBackButton: UINavigationItem!
    
    //Entry point of the view
    override func viewDidLoad() {
        
        // set underlying borders
        emailTextField.setBottomBorderTextField()
        nicknameTextField.setBottomBorderTextField()
        passwordTextField.setBottomBorderTextField()
        confirmPasswordTextField.setBottomBorderTextField()
        
        // set images with every textfield
        emailTextField.setTextFieldLeftIcon("mail.png")
        nicknameTextField.setTextFieldLeftIcon("user.png")
        passwordTextField.setTextFieldLeftIcon("lock.png")
        confirmPasswordTextField.setTextFieldLeftIcon("lock.png")
    
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        //send POST request to server
    }

}