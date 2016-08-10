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
    @IBOutlet weak var pokeballImage: UIImageView!
    
    // refference to the email text field
    @IBOutlet weak var emailTextField: UITextField!
    
    // refference to the login button field
    @IBOutlet weak var loginButton: UIButton!
    
    // refference password text filed
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.passwordTextField.secureTextEntry = true
        
        emailTextField.textFieldAsStandard("mail.png", bootomBorder: true)
        passwordTextField.textFieldAsStandard("lock.png", bootomBorder: true)
        
        checkIfValidLogin()
        
        dispatch_async(dispatch_get_main_queue(), {
            self.performAnimation()
            
        })
    }
    
    //test the registered data if there is a valid entry
    func checkIfValidLogin(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let valid:Bool = defaults.boolForKey("isEntered"){
            
            if valid {
         
                UserSingleton.sharedInstance.username = defaults.stringForKey("username")!
                UserSingleton.sharedInstance.email = defaults.stringForKey("email")!
                UserSingleton.sharedInstance.authToken = defaults.stringForKey("authToken")!
            
                //show the list
                showHomeController()
                
            }
        }
    }
    
    func performAnimation() {
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.pokeballImage.transform = CGAffineTransformRotate(self.pokeballImage.transform, CGFloat(0).advancedBy(0.2))
        }) { (finished) -> Void in
            self.performAnimation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
    }
    
    
    override func onResponseSuccess(data: NSData) {
        
        hideSpinner()
        
        do {
            
            let user: User = try Unbox(data)
            
            //set the singleton class variables
            UserSingleton.sharedInstance.authToken = user.authToken!
            UserSingleton.sharedInstance.email = user.email
            UserSingleton.sharedInstance.username = user.username
            self.hideSpinner()
            
            showHomeController()
            
        } catch _ {
            
            self.onParseError()
            
        }
        
    }
    
    func showHomeController() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("homeViewController")   as! HomeTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
    
        
        guard let username = emailTextField?.text where username.characters.count > 0,
            let password = passwordTextField?.text where password.characters.count > 0 else{
                
                animateTextFieldView(emailTextField)
                animateTextFieldView(passwordTextField)
                
                createAlertController(
                    "Mew is not pleased!",
                    message: "Please enter a valid username and password")
                
                return
        }
        
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


