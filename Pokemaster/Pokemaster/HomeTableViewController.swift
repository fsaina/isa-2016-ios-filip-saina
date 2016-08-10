//
//  HomeTableViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 19/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import Unbox

class HomeTableViewController: UITableViewController, newListItemDelegate {
    

    @IBOutlet weak var homeTableView: UITableView!
    
    private var pokeList:[Pokemon] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor(netHex:0x314E8F)

        loadListDataFromServer()
        
        let barBack = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeTableViewController.goBack))
        self.navigationItem.leftBarButtonItem = barBack
        
        let buttonAdd: UIButton = UIButton(type: UIButtonType.ContactAdd)
        buttonAdd.frame = CGRectMake(0, 0, 40, 40)
        buttonAdd.addTarget(self, action: #selector(HomeTableViewController.addNewPokemonBarItem), forControlEvents:UIControlEvents.TouchUpInside)
    
        let addNewPokemonButton: UIBarButtonItem = UIBarButtonItem(customView: buttonAdd)
        self.navigationItem.setRightBarButtonItem(addNewPokemonButton, animated: false)
        self.tableView.rowHeight = 56
        navigationItem.title = "Pokemaster"
        
        //set valid login user
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "isEntered")
        defaults.setObject(UserSingleton.sharedInstance.username, forKey: "username")
        defaults.setObject(UserSingleton.sharedInstance.email, forKey: "email")
        defaults.setObject(UserSingleton.sharedInstance.authToken, forKey: "authToken")
        
    }
    
    // method to execute on add new pokemon button click
    func addNewPokemonBarItem(){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addPokemonView") as! AddPokemonViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func goBack() {
        
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Content-Type": "text/html"
        ]
        
        showSpinner()
        
        Alamofire.request(.DELETE, "https://pokeapi.infinum.co/api/v1/users/logout",headers:headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    
                    //remove login data
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(false, forKey: "isEntered")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
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
                                "Error parsing the data",
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
    
    private func reloadList(){
        homeTableView.reloadData()
    }
    
    private func loadListDataFromServer(){
        
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Accept": "application/json"
        ]
        
        showSpinner()
        
        Alamofire.request(.GET, "https://pokeapi.infinum.co/api/v1/pokemons",headers:headers, encoding: .JSON)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    
                    if let data = response.data {
                        do{
                            let listResponse:PokemonListResponse = try Unbox(data)
                            self.pokeList = listResponse.data
                            self.tableView.reloadData()
                            self.hideSpinner()
                        
                        } catch _ {

                            self.createAlertController(
                                "Exception while parsing the data",
                                message: "An error occured while parsing the data -- please try again later")
                        }
                    } else {
                        self.createAlertController(
                            "Error getting the data",
                            message: "An error occured while parsing the data -- please try again later")
                    }
                    
                case .Failure(_):
                    self.createAlertController(
                        "Error parsing the data",
                        message: "An error occured while parsing the data -- please try again later")
                }
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.pokeList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCellWithIdentifier("pokemonCell") as! HomeTableViewCell!
        
        cell.pokemonNameLabel.text = self.pokeList[indexPath.section].name
        
        
        // Grab the image in its thread and load it here
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            
            if((self.pokeList[indexPath.section].imageUrl) != nil){
                let urlImage:String = "https://pokeapi.infinum.co" + self.pokeList[indexPath.section].imageUrl!
                
                print(urlImage) //debug
                
                let url = NSURL(string:urlImage)!
            
                if((NSData(contentsOfURL: url)) != nil){
                    let data = NSData(contentsOfURL: url)
                    let myImage =  UIImage(data: (data)!)
                
                
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.pokemonImageView.image = myImage
                        cell.pokemonImageView.layer.cornerRadius = cell.pokemonImageView.frame.size.width/2
                        cell.pokemonImageView.layer.borderWidth = 1
                        cell.pokemonImageView.layer.borderColor = UIColor.grayColor().CGColor
                        cell.pokemonImageView.layer.masksToBounds = true
                        cell.setNeedsLayout()
                    }
                }
            }
            
            
        })
        
        return cell
    }
    
    //what to do on click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        UserSingleton.sharedInstance.pokemonList = [self.pokeList[indexPath.section]]
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("pokemonDetailViewController") as! PokemonDescriptionTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addANewItem(item:Pokemon){
        self.pokeList.insert(item, atIndex: 0)
        tableView.reloadData()
    }

}


protocol newListItemDelegate {
    func addANewItem(item:Pokemon)
}


