//
//  AddPokemonViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 31/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

class AddPokemonViewController: BaseView, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DidSelectItemDelegate  {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var heightField: UITextField!
    
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var abilitiesButton: UIButton!
    
    @IBOutlet weak var DescriptionField: UITextField!
    
    @IBOutlet weak var loadImageButton: UIButton!
    
    //list of moves for the pokemon
    var pokemonMovesList:[SelectableDataHolder] = []
    
    //type of the pokemon
    var pokemonTypesList:[SelectableDataHolder] = []
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.textFieldAsStandard("user.png",bootomBorder: false)
        heightField.textFieldAsStandard("", bootomBorder: false)
        weightField.textFieldAsStandard("", bootomBorder: false)
        DescriptionField.textFieldAsStandard("document.png", bootomBorder: false)
        
        loadImageButton.layer.cornerRadius = 24

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addPhotoButtonPress(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    override func onResponseSuccess(data: NSData) {
        
        hideSpinner()
        
        do {
            
//            let user: User = try Unbox(data)
//            
//            //set the singleton class variables
//            UserSingleton.sharedInstance.authToken = user.authToken
//            UserSingleton.sharedInstance.email = user.email
//            UserSingleton.sharedInstance.username = user.username
//            self.hideSpinner()
//            
//            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("homeViewController")   as! HomeTableViewController
//            self.navigationController?.pushViewController(vc, animated: true)
            
        } catch _ {
            
            self.onParseError()
            
        }
        
    }
    
    @IBAction func saveButtonPress(sender: AnyObject) {
//        guard let username = emailTextField?.text where username.characters.count > 0,
//            let password = passwordTextField?.text where password.characters.count > 0 else{
//                
//                createAlertController(
//                    "Mew is not pleased!",
//                    message: "Please enter a valid username and password")
//                
//                return
//        }
//        
//        let params = ["data" : [
//            "type" : "session",
//            "attributes": [
//                "email": username,
//                "password": password
//            ]]]
//        
//        showSpinner()
//        performRequest(.POST, apiUlr: "https://pokeapi.infinum.co/api/v1/users/login", params: params, headers: nil)
    }
    
    
    
    @IBAction func typeButtonPress(sender: AnyObject) {
        
        //perfrom call to get all abilities
        
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Content-Type": "text/html"
        ]
        
        showSpinner()
        
        Alamofire.request(.GET, "https://pokeapi.infinum.co/api/v1/types",headers:headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let data = response.data {
                        
                        self.hideSpinner()
                        
                        do {
                            
                            let moves: Moves = try Unbox(data)
                            
                            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("selectFromListTableView") as! SelecItemTableViewController
                            
                            var items:[SelectableDataHolder] = []
                            for m in moves.data!{
                                items.append(SelectableDataHolder(text: m.name, idValue: m.id))
                            }
                            
                            vc.itemsList = items
                            vc.delegate = self
                            vc.id="TYPES"
                            
                            
                            self.navigationController?.showViewController(vc, sender: self)
                            
                        } catch _ {
                            
                            self.onParseError()
                            
                        }
                        
                    } else {
                        
                        self.onResponseError()
                        
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
    
    @IBAction func movesButtonPress(sender: AnyObject) {
        
        //perfrom call to get all abilities
        
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Content-Type": "text/html"
        ]
        
        showSpinner()
        
        Alamofire.request(.GET, "https://pokeapi.infinum.co/api/v1/moves",headers:headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let data = response.data {
                        
                        self.hideSpinner()
                        
                        do {
                            
                            let moves: Moves = try Unbox(data)
                            
                            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("selectFromListTableView") as! SelecItemTableViewController
                        
                            var items:[SelectableDataHolder] = []
                            for m in moves.data!{
                                items.append(SelectableDataHolder(text: m.name, idValue: m.id))
                            }
                            
                            vc.itemsList = items
                            vc.delegate = self
                            vc.id="MOVES"
                            
                            self.navigationController?.showViewController(vc, sender: self)
                            
                        } catch _ {
                            
                            self.onParseError()
                            
                        }
                        
                    } else {
                        
                        self.onResponseError()
                        
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
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imageView.image = image
        
    }
    
    func didSelectItem(items: [SelectableDataHolder], id:String){
        if(id == "MOVES" ){
            pokemonMovesList = items
        } else if(id == "TYPES"){
            pokemonTypesList = items
        }
    }

}


protocol DidSelectItemDelegate{
    func didSelectItem(items: [SelectableDataHolder], id:String)
}
