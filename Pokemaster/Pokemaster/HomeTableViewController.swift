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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func reloadList(){
        homeTableView.reloadData()
    }
    
    
    private func showSpinner(){
        MBProgressHUD.showHUDAddedTo(view, animated: true)
    }
    
    private func hideSpinner(){
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
    private func loadListDataFromServer(){
        
        
        //DEBUG--REMOVE LATER
        
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
        
        cell.pokemonNameLabel.text = self.pokeList[indexPath.item].name
        // cell.pokemonImageView.image = ""  //TODO
        
        return cell
    }

}


extension HomeViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
