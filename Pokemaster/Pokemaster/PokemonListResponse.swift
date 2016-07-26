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
    let type: String
    let name: String
    let imageUrl: String?
    var description: String?
    let height:Int
    let weight:Int
}

extension Pokemon: Unboxable{
    
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.type = unboxer.unbox("type")
        self.name = unboxer.unbox("attributes.name")
        self.imageUrl = unboxer.unbox("attributes.image-url")
        self.description = unboxer.unbox("attributes.description")
        self.height = unboxer.unbox("attributes.height")
        self.weight = unboxer.unbox("attributes.weight")
        
        if(self.description == nil){
            self.description = ""
        }
        
    }
    
}