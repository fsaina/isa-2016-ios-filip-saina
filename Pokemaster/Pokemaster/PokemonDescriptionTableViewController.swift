//
//  PokemonDescriptionTableViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 25/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit

class PokemonDescriptionTableViewController: UITableViewController {
    
    private var pokemonItemDescription:[PokemonDescriptionDataHolderProtocol] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        
        let pokemon:Pokemon
        
        pokemonItemDescription.append(PokemonDescriptionHolder(title: "asfd", description: "asdf"))
        pokemonItemDescription.append(PokemonTitleDescriptionHolder(title: "asdf", description: "aa"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return pokemonItemDescription.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellMember:PokemonDescriptionDataHolderProtocol = pokemonItemDescription[indexPath.section]
        
        switch cellMember {
        case is PokemonDescriptionHolder:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellMember.tableIdentifier) as! PokemonDescrptionTableViewCell
            let cellElement = cellMember as! PokemonDescriptionHolder
                
            cell.nameLabel.text = cellElement.titleText
            cell.descriptionLabel.text = cellElement.descriptionText
            return cell
            
        case is PokemonTitleDescriptionHolder:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellMember.tableIdentifier) as! TitleDescrptionTableViewCell
            let cellElement = cellMember as! PokemonTitleDescriptionHolder
            
            cell.titleLabel.text = cellElement.titleText
            cell.detailLabel.text = cellElement.descriptionText
            return cell
            
        default:
            return cellMember as! UITableViewCell
        }
    }
}