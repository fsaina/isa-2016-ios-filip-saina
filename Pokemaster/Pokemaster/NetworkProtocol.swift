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
    
    func performRequest(apiCallType:Alamofire.Method , apiUlr:String, params:Dictionary<String,AnyObject>) {
        
        Alamofire.request(apiCallType,
            apiUlr,
            parameters: params,
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
}


//default class implementation
class BaseView:UIViewController, NetworkableProtocol, AlertableProtocol{
    
    //must be set
    var viewRef:UIView = UIView()
    
    
    //dizaster -- swift has no abstract methods
    func onResponseSuccess(data:NSData){
        preconditionFailure("This method must be overridden")
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
        createAlertController(
            "Service unavailable",
            message: "An error occured -- please try again later")
    }
    
    func onParseError(){
        createAlertController(
            "Error parsing the data",
            message: "An error occured while parsing the data -- please try again later")
    }
    
    func onFailureResponseData(error:NSError){
        self.createAlertController(
            "Error",
            message: "\(error.localizedDescription)")
    }
    
    func onFailureError(data:NSData, errorObject:ErrorMessage){
        
        self.createAlertController(
            "Error with the \(errorObject.errorSubject()) field",
            message: "\(errorObject.errorMessageDetail)")
    }
}


