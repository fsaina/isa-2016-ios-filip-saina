//
//  AddCommentViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 10/08/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController {
    
    @IBOutlet weak var blur: UIView!
    @IBOutlet weak var addCommentButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blur.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3) {
            self.blur.alpha = 0.2
        }
    }
    
    @IBAction func dismissPopup() {
        
        UIView.animateWithDuration(0.3, animations:{
            self.blur.alpha = 0
            }, completion: {(finished:Bool) in
                
            self.dismissViewControllerAnimated(true) {
               //
            }
        })

    }

}
