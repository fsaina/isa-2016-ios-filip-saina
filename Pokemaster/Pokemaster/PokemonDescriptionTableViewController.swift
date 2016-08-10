//
//  PokemonDescriptionTableViewController.swift
//  Pokemaster
//
//  Created by Filip Saina on 25/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

class PokemonDescriptionTableViewController: BaseView, CommentAddedDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    private var pokemonItemDescription:[PokemonDescriptionDataHolderProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        
        let pokemon:Pokemon = UserSingleton.sharedInstance.pokemonList[0]
        
        if(pokemon.imageUrl != nil){
            pokemonItemDescription.append(PokemonImageViewHolder(url: pokemon.imageUrl!))
        }
        
        pokemonItemDescription.append(PokemonDescriptionHolder(title: pokemon.name,description: pokemon.description!))
        pokemonItemDescription.append(PokemonTitleDescriptionHolder(title: "Height", description: String(pokemon.height)))
        pokemonItemDescription.append(PokemonTitleDescriptionHolder(title: "Weight", description: String(pokemon.weight)))
        pokemonItemDescription.append(PokemonTitleDescriptionHolder(title: "Type", description: pokemon.type!))
        pokemonItemDescription.append(PokemonLikeDislikeHolder())
        
        for comm in pokemon.comments.data!{
            let comment:String = comm.comment
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                let headers = [
                    "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
                    "Accept": "application/json"
                ]
                
                Alamofire.request(.GET, "https://pokeapi.infinum.co/api/v1/users/"+String(comm.authorId),headers:headers, encoding: .JSON)
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            
                            if let data = response.data {
                                do{
                                    let user: User = try Unbox(data)
                                    
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.pokemonItemDescription.insert(PokemonCommentHolder(comment: comment, date: "", username: user.username), atIndex:self.pokemonItemDescription.count-1)
                                        self.tableView.reloadData()
                                    }
                                    
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

                
                
                
            })
            
            
        }
        pokemonItemDescription.append(PokemonAddCommendHolder())
        
        navigationItem.title = pokemon.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onResponseSuccess(data: NSData) {
        
        hideSpinner()
        
    }
    
}

extension PokemonDescriptionTableViewController: UITableViewDataSource{
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return pokemonItemDescription.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
            
        case is PokemonLikeDislikeHolder:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellMember.tableIdentifier) as! LikeDislikeTableViewCell
            cell.likeButton.addTarget(self, action: #selector(PokemonDescriptionTableViewController.likeButtonClick), forControlEvents: .TouchUpInside)
            cell.dislikeButton.addTarget(self, action: #selector(PokemonDescriptionTableViewController.dislikeButtonClike), forControlEvents: .TouchUpInside)
            
            return cell
            
        case is PokemonCommentHolder:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellMember.tableIdentifier) as! CommentTableViewCell
            let cellElement = cellMember as! PokemonCommentHolder
            
            cell.usernameLabel.text = cellElement.username
            cell.commentLabel.text = cellElement.comment
            cell.dateLabel.text = cellElement.date
            
            return cell
            
        case is PokemonAddCommendHolder:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellMember.tableIdentifier) as! AddCommentTableViewCell
            
            cell.addCommentButton.addTarget(self, action: #selector(PokemonDescriptionTableViewController.addCommentClick), forControlEvents: .TouchUpInside)
            
            return cell
            
        case is PokemonImageViewHolder:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellMember.tableIdentifier) as! ImageTableViewCell
            let cellElement = cellMember as! PokemonImageViewHolder
            
            
            // Grab the image in its thread and load it here
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                let urlImage:String = "https://pokeapi.infinum.co" + cellElement.url
                
                let url = NSURL(string:urlImage)!
                
                if((NSData(contentsOfURL: url)) != nil){
                    let data = NSData(contentsOfURL: url)
                    let myImage =  UIImage(data: (data)!)
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.imageView?.image = myImage
                        
                        cell.setNeedsLayout()
                        
                        cell.imageView?.contentMode = .ScaleAspectFit
                    }
                }
                
            })
            
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier(cellMember.tableIdentifier)! as UITableViewCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cellMember:PokemonDescriptionDataHolderProtocol = pokemonItemDescription[indexPath.section]
        return CGFloat(cellMember.cellHeight)
    }
    
    func addCommentClick(button:UIButton){
    
        let vc = storyboard?.instantiateViewControllerWithIdentifier("popup") as! AddCommentViewController
        vc.modalPresentationStyle = .OverCurrentContext
        
        vc.delegate = self
        navigationController?.presentViewController(vc, animated: true, completion: {
            
        })
        
    }
    
    func likeButtonClick(button:UIButton){
        showSpinner()
        let urlUpvote:String = "https://pokeapi.infinum.co/api/v1/pokemons/" + String(UserSingleton.sharedInstance.pokemonList[0].id)
        + "/upvote"
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Content-Type": "text/html"
        ]
        performRequest(.POST, apiUlr: urlUpvote, params: nil, headers: headers)
    }
    
    func dislikeButtonClike(button:UIButton){
        
        showSpinner()
        let urlUpvote:String = "https://pokeapi.infinum.co/api/v1/pokemons/" + String(UserSingleton.sharedInstance.pokemonList[0].id)
            + "/downvote"
        let headers = [
            "Authorization": "Token token=\(UserSingleton.sharedInstance.authToken), email=\(UserSingleton.sharedInstance.email)",
            "Content-Type": "text/html"
        ]
        performRequest(.POST, apiUlr: urlUpvote, params:nil, headers: headers)
    }
    
    func commentAdded(comment: String) {
        self.pokemonItemDescription.insert(PokemonCommentHolder(comment: comment, date: "", username: UserSingleton.sharedInstance.username), atIndex:self.pokemonItemDescription.count-1)
        tableView.reloadData()
    }
    
}

extension PokemonDescriptionTableViewController: UITableViewDelegate{
    //what to do on click
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

protocol CommentAddedDelegate {
    func commentAdded(name: String)
}