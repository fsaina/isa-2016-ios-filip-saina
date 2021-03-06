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

struct PokemonCreateResponse{
    let data:Pokemon
}

extension PokemonCreateResponse:Unboxable{
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
    var comments:Comments
    var image:UIImage?
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
        self.image = nil
        
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
    var data:[CommentEntry]?
//    let included:[Included]?
}

extension Comments:Unboxable{
    init(unboxer: Unboxer) {
        self.data = unboxer.unbox("data")
//        self.included = unboxer.unbox("included")
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
        self.comment = unboxer.unbox("content")
        self.authorId = unboxer.unbox("author-id")
    }
}


struct Moves{
    
    let data:[Move]?
    
}

extension Moves:Unboxable{
    init(unboxer: Unboxer) {
        self.data = unboxer.unbox("data")
    }
}

struct Move {
    
    let id:String
    let name:String
    
}

extension Move:Unboxable{
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.name = unboxer.unbox("attributes.name")
    }
}

