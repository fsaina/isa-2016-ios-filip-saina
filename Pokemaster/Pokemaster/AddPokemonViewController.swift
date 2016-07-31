//
//  AddPokemonViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 31/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

class AddPokemonViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var heightField: UITextField!
    
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var typeField: UITextField!
    
    @IBOutlet weak var abilitiesButton: UIButton!
    
    @IBOutlet weak var DescriptionField: UITextField!
    
    @IBOutlet weak var loadImageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.textFieldAsStandard("user.png",bootomBorder: false)
        heightField.textFieldAsStandard("", bootomBorder: false)
        weightField.textFieldAsStandard("", bootomBorder: false)
        typeField.textFieldAsStandard("", bootomBorder: false)
        DescriptionField.textFieldAsStandard("document.png", bootomBorder: false)
        
        loadImageButton.layer.cornerRadius = 24
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
