//
//  PokemonListResponse.swift
//  Pokemaster
//
//  Created by Filip Saina on 22/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import Foundation
import Unbox

struct PokemonListResponse {
    let data: [Pokemon]
}

extension PokemonListResponse: Unboxable{
    init(unboxer: Unboxer) {
        self.data = unboxer.unbox("data")
    }
}

struct Pokemon{
    
    let id: Int
    var type: String?
    let name: String
    let imageUrl: String?
    var description: String?
    let height:Int
    let weight:Int
    let comments:Comments
}

extension Pokemon: Unboxable{
    
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.type = unboxer.unbox("relationships.types.data.0.name")
        self.name = unboxer.unbox("attributes.name")
        self.imageUrl = unboxer.unbox("attributes.image-url")
        self.description = unboxer.unbox("attributes.description")
        self.height = unboxer.unbox("attributes.height")
        self.weight = unboxer.unbox("attributes.weight")
        self.comments = unboxer.unbox("relationships.comments")
        
        if(self.description == nil){
            self.description = ""
        }
        
        if(self.type == nil){
            self.type = "Undefined :("
        }
        
    }
    
}

//might work -- might not

struct Comments{
    let data:[CommentEntry]?
    let included:[Included]?
}

extension Comments:Unboxable{
    init(unboxer: Unboxer) {
        self.data = unboxer.unbox("data")
        self.included = unboxer.unbox("included")
    }
}

struct Included{
    let userId:Int
    let username:String
}

extension Included: Unboxable{
    init(unboxer: Unboxer) {
        self.userId = unboxer.unbox("id")
        self.username = unboxer.unbox("attributes.username")
    }
}

struct CommentEntry{
    
    let id:Int
    let comment:String
    let authorId:Int
    
}

extension CommentEntry: Unboxable{
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.comment = unboxer.unbox("attributes.content")
        self.authorId = unboxer.unbox("relationships.author.data.id")
    }
}



