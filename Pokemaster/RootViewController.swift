//
//  RootViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 04/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        
        emailTextField.setTextFieldLeftIcon("mail.png")
        emailTextField.setBottomBorderTextField();
        
        passwordTextField.setTextFieldLeftIcon("lock.png")
        passwordTextField.setBottomBorderTextField();
        
    }
    
    
    func hideHUDWithDelay(){
        MBProgressHUD.hideHUDForView(view, animated:true)
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        performSelector(#selector(RootViewController.hideHUDWithDelay), withObject: nil, afterDelay: 3.0)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
