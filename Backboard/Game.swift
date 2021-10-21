//
//  Game.swift
//  Backboard
//
//  Created by Cole Kauppinen on 10/21/21.
//

import Foundation
import SwiftyJSON

class Game {
    
    var gameId: String
    var arena: JSON
    var attendance: String
    var clock: String
    var period: String
    var gameStatus: Int
    var awayTeam: JSON
    var homeTeam: JSON
    
    //Creates a pizza with the corresponding ingredients and specifications
    init(gameId:String, arena:JSON, attendance: String, clock:String, period:String, gameStatus:Int, awayTeam:JSON, homeTeam:JSON){
        self.gameId = gameId
        self.arena = arena
        self.attendance = attendance
        self.clock = clock
        self.period = period
        self.gameStatus = gameStatus
        self.awayTeam = awayTeam
        self.homeTeam = homeTeam
    }
}
