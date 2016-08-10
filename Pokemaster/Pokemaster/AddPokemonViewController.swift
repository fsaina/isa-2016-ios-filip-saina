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
import SwiftyJSON

class AddPokemonViewController: BaseView, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DidSelectItemDelegate  {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var heightField: UITextField!
    
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var typebutton: UIButton!
    
    @IBOutlet weak var abilitiesButton: UIButton!
    
    @IBOutlet weak var DescriptionField: UITextField!
    
    @IBOutlet weak var loadImageButton: UIButton!
    
    //list of moves for the pokemon
    var pokemonMovesList:[SelectableDataHolder] = []
    
    //type of the pokemon
    var pokemonTypesList:[SelectableDataHolder] = []
    
    var imagePicker = UIImagePickerController()
    
    var delegate: newListItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.textFieldAsStandard("user.png",bootomBorder: false)
        heightField.textFieldAsStandard("", bootomBorder: false)
        weightField.textFieldAsStandard("", bootomBorder: false)
        DescriptionField.textFieldAsStandard("document.png", bootomBorder: false)
        navigationItem.title = "Add new pokemon"
        
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
    }
    
    @IBAction func saveButtonPress(sender: AnyObject) {
        
        guard let _ = nameField?.text where nameField.text!.characters.count > 0,
            let username = heightField?.text where username.characters.count > 0,
            let password = weightField?.text where password.characters.count > 0,
            let passwordConfirm = DescriptionField?.text where passwordConfirm.characters.count > 0 else{
                
                if(self.pokemonTypesList.count == 0 || self.pokemonMovesList.count == 0){
                 
                    createAlertController(
                        "Error",
                        message: "Not all fields are fulfilled")
                    
                }
                
            return
                
        }
        
        var types:[String] = []
        for i in self.pokemonTypesList{
            types.append(i.idValue)
        }
        
        var moves:[String] = []
        for i in self.pokemonMovesList{
            moves.append(i.idValue)
        }
        
        let paramsJSON = JSON(types)
        let typesFin = paramsJSON.rawString(NSUTF8StringEncoding)
        
        let paramsJSON2 = JSON(moves)
        let movesFin = paramsJSON2.rawString(NSUTF8StringEncoding)
        
        // TODO add moves, types to the list below!
        let attributes:[String:AnyObject] = [
            "name" : nameField.text!,
            "height" : heightField.text!,
            "weight" : weightField.text!,
            "order" : "36",
            "gender_id": "1",
            "is_default": "true",
            "base_experience": "20",
            "type_ids": typesFin!,
            "move_ids": movesFin!,
            "description": DescriptionField.text!
        ]
        
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Content-Type": "text/html"
        ]
        
        
        Alamofire.upload(.POST, "https://pokeapi.infinum.co/api/v1/pokemons", headers: headers, multipartFormData: {
            multipartFormData in
            if let image = self.imageView.image {
                if let imageData = UIImageJPEGRepresentation(image, 0.8) {
                    multipartFormData.appendBodyPart(data: imageData, name: "data[attributes][image]", fileName: "file.jpeg", mimeType: "image/jpeg")
                }
            }
            for (key, value) in attributes {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: "data[attributes][" + key + "]")
            }
            }, encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    
                    upload.responseString(completionHandler: { (response) in
                    if let data = response.data {
                        do{
                        let stringdata = String(data: data, encoding: NSUTF8StringEncoding)
                        print(stringdata!)
                        let pokemon: PokemonCreateResponse = try Unbox(data)
                        self.delegate?.addANewItem(pokemon.data)
                        } catch _ {
                            self.createAlertController(
                                "Error",
                                message: "Sorry, there was an error creating while parsing a new pokemon")

                        }
                    }
                    })
                    self.navigationController!.popViewControllerAnimated(true)
                case .Failure( _):
                    self.createAlertController(
                        "Error",
                        message: "Sorry, there was an error creating a new pokemon")
                }
        })
        
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
