//
//  PokemonDescrptionTableViewCell.swift
//  Pokemaster
//
//  Created by Filip Saina on 25/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

protocol PokemonDescriptionDataHolderProtocol {
    var tableIdentifier:String { get }
}


struct PokemonDescriptionHolder: PokemonDescriptionDataHolderProtocol  {
    
    
    var titleText:String
    var descriptionText:String
    
    init(title:String, description:String){
        self.titleText = title
        self.descriptionText = description
    }
    
    var tableIdentifier: String {
        return "descriptionCell"
    }
    
}

struct PokemonTitleDescriptionHolder: PokemonDescriptionDataHolderProtocol {
    
    var titleText:String
    var descriptionText:String
    
    init(title:String, description:String){
        self.titleText = title
        self.descriptionText = description
    }
    
    var tableIdentifier: String {
        return "dataCell"
    }
}

struct PokemonLikeDislikeHolder: PokemonDescriptionDataHolderProtocol {
    var tableIdentifier: String {
        return "likeCell"
    }
}

struct PokemonCommentHolder: PokemonDescriptionDataHolderProtocol {
    
    var comment:String
    var date:String
    var username:String
    
    init(comment:String, date:String, username:String){
        self.comment = comment
        self.date = date
        self.username = username
    }
    
    var tableIdentifier: String {
        return "commentCell"
    }
    
}

struct PokemonImageViewHolder: PokemonDescriptionDataHolderProtocol{
    var url:String
    
    init(url:String){
        self.url = url
    }
    
    var tableIdentifier: String {
        return "imageCell"
    }
}




