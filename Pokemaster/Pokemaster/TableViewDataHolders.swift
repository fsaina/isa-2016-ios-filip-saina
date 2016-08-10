//
//  PokemonDescrptionTableViewCell.swift
//  Pokemaster
//
//  Created by Filip Saina on 25/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

protocol PokemonDescriptionDataHolderProtocol {
    var tableIdentifier:String { get }
    var cellHeight:Int { get }
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
    
    var cellHeight: Int{
        return 100
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
    
    var cellHeight: Int{
        return 40
    }
}

struct PokemonAddCommendHolder: PokemonDescriptionDataHolderProtocol{
    
    var tableIdentifier: String {
        return "addCommentCell"
    }
    
    var cellHeight: Int{
        return 40
    }
    
}

struct PokemonLikeDislikeHolder: PokemonDescriptionDataHolderProtocol {
    var tableIdentifier: String {
        return "likeCell"
    }
    
    var cellHeight: Int{
        return 120
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
    
    var cellHeight: Int{
        return 100
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
    
    var cellHeight: Int{
        return 170
    }
}




