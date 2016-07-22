//
//  HomeTableViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 19/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeTableViewController: UITableViewController {
    
    

    @IBOutlet weak var homeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showSpinner()
        loadListDataFromServer()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func loadListDataFromServer(){
        
        // Now onto networking
        let params = ["user": ["email": username, "password": password]]
    
        Alamofire.request(.POST,
            "https://pokeapi.infinum.co/api/v1/users/login",
            parameters: params,
            encoding: .JSON).validate().responseJSON {(response) in
                
                switch response.result {
                case .Success:
                    
                    if let data = response.data {
                        do {
                            
                            //TODO method to show data
                            
                        } catch _ {
                            self.createAlertController(
                                "Error parsing the data",
                                message: "An error occured while parsing the data -- please try again later")
                        }
                    } else {
                        self.createAlertController(
                            "Service unavailable",
                            message: "An error occured -- please try again later")
                    }
                    
                case .Failure(let error):
                    self.createAlertController(
                        "Error",
                        message: "\(error.localizedDescription)")
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func showSpinner(){
        MBProgressHUD.showHUDAddedTo(view, animated: true)
    }
    
    private func hideSpinner(){
        MBProgressHUD.hideHUDForView(view, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCellWithIdentifier("pokemonCell") as! HomeTableViewCell!
        
        cell.pokemonNameLabel.text = "asfads"
        cell.pokemonImageView.image = ""  //TODO
        
        return cell
    }

}


extension HomeViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        print(indexPath)
    }
    
}
