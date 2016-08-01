//
//  NetworkProtocol.swift
//  Pokemaster
//
//  Created by Filip Saina on 25/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import Alamofire
import Unbox
import MBProgressHUD
import UIKit

/**
 * Every network access view needs to yeld to this protocol
 */

protocol NetworkableProtocol {
    
    func onResponseSuccess(data:NSData)
    func onParseError()
    func onResponseError()
    func onFailureError(data:NSData, errorObject:ErrorMessage)
    func onFailureResponseData(error:NSError)
    
}

/**
 * Every alertable view needs to yeld to this protocol
 */

protocol AlertableProtocol {
    
    func createAlertController(title:String, message:String)
    
}

extension NetworkableProtocol{
    
    func performRequest(apiCallType:Alamofire.Method , apiUlr:String, params:Dictionary<String,AnyObject>?,headers:Dictionary<String,String>?) {
        
        
        Alamofire.request(apiCallType,
            apiUlr,
            parameters: params,
            headers: headers,
            encoding: .JSON).validate().responseJSON {(response) in
                
                switch response.result {
                case .Success:
                    
                    if let data = response.data {
                        
                        self.onResponseSuccess(data)
                        
                    } else {
                        
                        self.onResponseError()
                        
                    }
                    
                case .Failure(let error):
                    if let data = response.data {
                        
                        print("Error data: \(error.localizedDescription))") //print log for developer
                        
                        do{
                            let errorObject: ErrorMessage = try Unbox(data)
                            self.onFailureError(data, errorObject: errorObject)
                            
                        } catch _ {
                            
                            self.onParseError()
                            
                        }
                        
                    } else {
                        
                        self.onFailureResponseData(error)
                        
                    }
                    
                }
        }
    }
    
    func createAlertController(title: String, message: String) {
        
    }
    
    func onResponseError(){
        
    }
    
    func onParseError(){
        
    }
    
    func onFailureResponseData(error:NSError){
        
    }
    
    func onFailureError(data:NSData, errorObject:ErrorMessage){
        
    }
    
}

/*
 * Default class implementation containin the base logic for network manipulation
 * In order to use:  - override onResponseSuccess 
 *
 * Note: this class does not set spinners
 */

class BaseView:UIViewController, NetworkableProtocol, AlertableProtocol{
    
    //dizaster -- swift has no abstract methods
    func onResponseSuccess(data:NSData){
        preconditionFailure("This method must be overridden")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor(netHex:0x314E8F)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
       
    }
    
    
    
    func createAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func onResponseError(){
        
        hideSpinner()
        createAlertController(
            "Service unavailable",
            message: "An error occured -- please try again later")
    }
    
    func onParseError(){
        
        hideSpinner()
        createAlertController(
            "Error parsing the data",
            message: "An error occured while parsing the data -- please try again later")
    }
    
    func onFailureResponseData(error:NSError){
        
        hideSpinner()
        self.createAlertController(
            "Error",
            message: "\(error.localizedDescription)")
    }
    
    func onFailureError(data:NSData, errorObject:ErrorMessage){
        
        hideSpinner()
        self.createAlertController(
            "Error with the \(errorObject.errorSubject()) field",
            message: "\(errorObject.errorMessageDetail)")
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


