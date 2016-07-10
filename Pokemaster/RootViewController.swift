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
        
        setBottomBorderTextField(emailTextField)
        setBottomBorderTextField(passwordTextField)
        
        setTextFieldLeftIcoc(emailTextField, imageString: "lock.png")
        setTextFieldLeftIcoc(passwordTextField, imageString: "mail.png")
        
    }
    
    private func setTextFieldLeftIcoc(textField: UITextField, imageString: String!){
        
        let imageView = UIImageView();
        let image = UIImage(named: imageString);
        
        imageView.image = image;
        imageView.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        textField.leftView = imageView;
        textField.leftViewMode = UITextFieldViewMode.Always
    }
    
    private func setBottomBorderTextField(textField: UITextField){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
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
