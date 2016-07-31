//
//  RegisterViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 10/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import Unbox

/**
 * Login view controller class. Contains all the necessary logic for
 * handling the login process.
 */
class RegisterViewController: BaseView {
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var navigationViewBackButton: UINavigationItem!

    @IBOutlet weak var registerButton: UIButton!

    override func viewWillDisappear(animated: Bool) {
        //make the navigation controller white
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
    }
    
    //Entry point of the view
    override func viewDidLoad() {
        
        // set images with every textfield
        emailTextField.textFieldAsStandard("mail.png", bootomBorder: true)
        nicknameTextField.textFieldAsStandard("user.png", bootomBorder: true)
        passwordTextField.textFieldAsStandard("lock.png", bootomBorder: true)
        confirmPasswordTextField.textFieldAsStandard("lock.png", bootomBorder: true)
        
    
    }
    
    override func onResponseSuccess(data: NSData) {
        
        hideSpinner()
        
        do {
            let user: User = try Unbox(data)
            
            //set the singleton class variables
            UserSingleton.sharedInstance.authToken = user.authToken
            UserSingleton.sharedInstance.email = user.email
            UserSingleton.sharedInstance.username = user.username
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("homeViewController") as! HomeTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        } catch _ {
            
            self.onParseError()
            
        }
    }


    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        guard let email = emailTextField?.text where email.characters.count > 0,
            let username = nicknameTextField?.text where username.characters.count > 0,
            let password = passwordTextField?.text where password.characters.count > 0,
            let passwordConfirm = confirmPasswordTextField?.text where passwordConfirm.characters.count > 0 else{
                
                createAlertController(
                    "Hej newbie!",
                    message: "Not all fields are fulfilled")
                
                return
        }
        
        let params = ["data":[
                            "type": "users",
                            "attributes" : [
                                "username": username,
                                "email": email,
                                "password": password,
                                "password_confirmation": passwordConfirm
            ]]]
    
        
        showSpinner()
        performRequest(.POST, apiUlr: "https://pokeapi.infinum.co/api/v1/users/", params: params, headers: nil)
        
    }

}