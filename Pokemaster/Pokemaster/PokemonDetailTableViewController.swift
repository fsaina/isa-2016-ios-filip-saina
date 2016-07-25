//
//  TableViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 18/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

class PokemonDetailTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as! Pokemon2TableViewCell
            
            
            cell.pokemonNameLabel.text = "Bulbasaur"
            cell.pokemonDescriptionLabel.text = "tralalalla"
            
            return cell
            
        
    }
 
}
