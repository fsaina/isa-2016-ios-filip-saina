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
class LoginViewController: UIViewController {
    
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
    
    
    func hideHUDWithDelay(){
        MBProgressHUD.hideHUDForView(view, animated:true)
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    private func showSpinner(){
        MBProgressHUD.showHUDAddedTo(view, animated: true)
    }
    
    private func hideSpinner(){
        MBProgressHUD.hideHUDForView(view, animated: true)
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
        
        Alamofire.request(.POST,
            "https://pokeapi.infinum.co/api/v1/users/login",
            parameters: params,
            encoding: .JSON).validate().responseJSON {(response) in
            
            switch response.result {
            case .Success:
                
                if let data = response.data {
                    do {
                        let user: User = try Unbox(data)
                        
                        //set the singleton class variables
                        UserSingleton.sharedInstance.authToken = user.authToken
                        UserSingleton.sharedInstance.email = user.email
                        UserSingleton.sharedInstance.username = user.username
                        self.hideSpinner()
                        
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("homeViewController") as! HomeTableViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    } catch _ {
                        self.createAlertController(
                            "Error parsing the data",
                            message: "An error occured while parsing the data -- please try again later")
                    }
                } else {
                    self.createAlertController(
                        "Service unavailable",
                        message: "An error occured -- please try again later")
                }
                
            case .Failure(let error):
                if let data = response.data {
                    print("Error data: \(error.localizedDescription))")
                    do{
                        
                        let errorObject: ErrorMessage = try Unbox(data)
                        
                        
                        self.createAlertController(
                            "Error with the \(errorObject.errorSubject()) field",
                            message: "\(errorObject.errorMessageDetail)")
                        
                    } catch _ {
                        
                        
                        self.createAlertController(
                            "Error parsing the error data",
                            message: "An error occured while parsing the error data -- please try again later")
                    }
                } else {
                    
                    self.createAlertController(
                        "Error",
                        message: "\(error.localizedDescription)")
                }
                
            }
        }

    
    }

    private func createAlertController(title:String, message:String){
        self.hideSpinner()
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
