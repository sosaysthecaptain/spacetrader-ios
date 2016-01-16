//
//  SavedGame.swift
//  SpaceTrader
//
//  Created by Marc Auger on 1/15/16.
//  Copyright © 2016 Marc Auger. All rights reserved.
//

import Foundation

class SavedGame: NSObject, NSCoding {
    var savedGames: [NamedSavedGame]
    
    // autosave stuff
    var name: String = ""
    //let timestamp:
    
    var savedCommander: Commander
    var savedGalaxy: Galaxy
    var gameInProgress: Bool
    
    init(name: String, cdr: Commander, gxy: Galaxy, gameInProgress: Bool, savedGames: [NamedSavedGame]) {
        self.name = name
        self.savedCommander = cdr
        self.savedGalaxy = gxy
        self.gameInProgress = gameInProgress
        self.savedGames = []
        
    }
    
    // NSCODING METHODS
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObjectForKey("name") as! String
        self.savedCommander = decoder.decodeObjectForKey("savedCommander") as! Commander
        self.savedGalaxy = decoder.decodeObjectForKey("savedGalaxy") as! Galaxy
        self.gameInProgress = decoder.decodeObjectForKey("gameInProgress") as! Bool
        self.savedGames = decoder.decodeObjectForKey("savedGames") as! [NamedSavedGame]

        super.init()
    }

    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(name, forKey: "name")
        encoder.encodeObject(savedCommander, forKey: "savedCommander")
        encoder.encodeObject(savedGalaxy, forKey: "savedGalaxy")
        encoder.encodeObject(gameInProgress, forKey: "gameInProgress")
        encoder.encodeObject(savedGames, forKey: "savedGames")
    }
}

class NamedSavedGame: NSObject, NSCoding {
    var name: String = ""
    // timestamp
    var savedCommander: Commander
    var savedGalaxy: Galaxy
    
    init(name: String, cdr: Commander, gxy: Galaxy) {
        self.name = name
        self.savedCommander = cdr
        self.savedGalaxy = gxy
    }
    
    // NSCODING METHODS
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObjectForKey("name") as! String
        self.savedCommander = decoder.decodeObjectForKey("savedCommander") as! Commander
        self.savedGalaxy = decoder.decodeObjectForKey("savedGalaxy") as! Galaxy
        
        super.init()
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(name, forKey: "name")
        encoder.encodeObject(savedCommander, forKey: "savedCommander")
        encoder.encodeObject(savedGalaxy, forKey: "savedGalaxy")
    }

}