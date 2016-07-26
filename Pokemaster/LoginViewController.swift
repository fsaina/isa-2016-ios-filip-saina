//
//  RootViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 04/07/16.
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
class LoginViewController: BaseView{
    
    // refference to the email text field
    @IBOutlet weak var emailTextField: UITextField!
    
    // refference to the login button field
    @IBOutlet weak var loginButton: UIButton!
    
    // refference password text filed
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
        
        emailTextField.textFieldAsStandard("mail.png")
        passwordTextField.textFieldAsStandard("lock.png")
        
    }
    
    
    
    override func onResponseSuccess(data: NSData) {
        
        hideSpinner()
        
        do {
            
            let user: User = try Unbox(data)
            
            //set the singleton class variables
            UserSingleton.sharedInstance.authToken = user.authToken
            UserSingleton.sharedInstance.email = user.email
            UserSingleton.sharedInstance.username = user.username
            self.hideSpinner()
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("homeViewController")   as! HomeTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        } catch _ {
            
            self.onParseError()
            
        }
        
    }
    
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
    
        
        guard let username = emailTextField?.text where username.characters.count > 0,
            let password = passwordTextField?.text where password.characters.count > 0 else{
                
                createAlertController(
                    "Mew is not pleased!",
                    message: "Please enter a valid username and password")
                
                return
        }
        
        // Now onto networking
        let params = ["data" : [
            "type" : "session",
            "attributes": [
                "email": username,
                "password": password
            ]]]
        
        showSpinner()
        performRequest(.POST, apiUlr: "https://pokeapi.infinum.co/api/v1/users/login", params: params, headers: nil)
        
    }
    
    
    
    
}


extension UIViewController{
    func showSpinner(){
        MBProgressHUD.showHUDAddedTo(view, animated: true)
    }
    
    func hideSpinner(){
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
}

