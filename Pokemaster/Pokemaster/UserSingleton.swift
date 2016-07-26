//
//  SingletonUser.swift
//  Pokemaster
//
//  Created by Filip Saina on 22/07/16.
//  Copyright © 2016 InfinumAcademy. All rights reserved.
//

import Foundation

class UserSingleton {
    static let sharedInstance = UserSingleton()
    
    // authorization token returned by the server
    var authToken: String
    
    // email of the user
    var email: String
    
    //username of the user
    var username: String
    
    //pokemons
    var pokemonList:[Pokemon]
    
    //private constructor
    private init() {
        authToken = ""
        email = ""
        username = ""
        pokemonList = []
    }
}
