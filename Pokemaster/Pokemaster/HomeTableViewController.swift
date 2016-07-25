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

class HomeTableViewController: UITableViewController {
    

    @IBOutlet weak var homeTableView: UITableView!
    
    private var pokeList:[Pokemon] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadListDataFromServer()
        
        let barBack = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeTableViewController.goBack))
        self.navigationItem.leftBarButtonItem = barBack
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
                    
                case .Failure(let error):
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
        // cell.pokemonImageView.image = ""  //TODO
        
        return cell
    }

}



