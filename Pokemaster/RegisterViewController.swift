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
class RegisterViewController: UIViewController {
    
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
        //make the navigation controller blue
        self.navigationController!.navigationBar.barTintColor = registerButton.backgroundColor
        
        // set images with every textfield
        emailTextField.textFieldAsStandard("mail.png")
        nicknameTextField.textFieldAsStandard("user.png")
        passwordTextField.textFieldAsStandard("lock.png")
        confirmPasswordTextField.textFieldAsStandard("lock.png")
        
    
    }
    
    private func showSpinner(){
        MBProgressHUD.showHUDAddedTo(view, animated: true)
    }
    
    private func hideSpinner(){
        MBProgressHUD.hideHUDForView(view, animated: true)
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
        
        let params = ["user": [
            "username": username,
            "email": email,
            "password": password,
            "password_confirmation": passwordConfirm]]
        
        showSpinner()
        
        
        Alamofire.request(.POST,
            "https://pokeapi.infinum.co/api/v1/users/",
            parameters: params,
            encoding: .JSON).validate().responseJSON {(response) in
                
                switch response.result {
                case .Success:
                    
                    if let data = response.data {
                        do {
                            let user: User = try Unbox(data)
                            //TODO store user
                            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
                            self.presentViewController(vc, animated:true, completion:nil)
                            
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
                    self.createAlertController(
                        "Error",
                        message: "\(error.localizedDescription)")
                }
        }
        
        
    }

}