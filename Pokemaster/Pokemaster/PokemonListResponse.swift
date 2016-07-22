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
}

extension Pokemon: Unboxable{
    
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.type = unboxer.unbox("type")
        self.name = unboxer.unbox("attributes.name")
    }
    
}