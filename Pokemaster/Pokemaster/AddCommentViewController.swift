//
//  AddCommentViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 10/08/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

class AddCommentViewController: BaseView {
    
    var delegate: CommentAddedDelegate?
    
    @IBOutlet weak var blur: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var addCommentButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blur.alpha = 0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(AddCommentViewController.blurAreaPress(_:)))
        blur.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3) {
            self.blur.alpha = 0.5
        }
    }
    
    //hide the comment area on blur element press
    func blurAreaPress(sender:UITapGestureRecognizer){
        hideSpinner()
        
        UIView.animateWithDuration(0.3, animations:{
            self.blur.alpha = 0
            }, completion: {(finished:Bool) in
                self.dismissViewControllerAnimated(true) {
                }
        })
    }
    
    //action when the add commnet button is pressed
    @IBAction func dismissPopup() {
        guard let comment = commentTextView?.text where comment.characters.count > 0 else{
                createAlertController(
                    "Error sending comment",
                    message: "Please enter a non-blank comment entry")
                return
        }
        
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Content-Type": "application/json"
        ]
        
        let params = [
            "data" : [
            "attributes": [
                "content": comment
            ]
            ]
        ]
        
        showSpinner()
        let pokemonId:Int = UserSingleton.sharedInstance.pokemonList[0].id
        performRequest(.POST, apiUlr: "https://pokeapi.infinum.co/api/v1/pokemons/"+String(pokemonId)+"/comments", params: params, headers: headers)
        
    }
    
    override func onResponseSuccess(data: NSData) {
        
        hideSpinner()
        
        UIView.animateWithDuration(0.3, animations:{
            self.blur.alpha = 0
            }, completion: {(finished:Bool) in
                
                self.dismissViewControllerAnimated(true) {
                    self.delegate?.commentAdded(self.commentTextView.text)
                }
        })
    }

}
