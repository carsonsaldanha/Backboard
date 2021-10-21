//
//  Game.swift
//  Backboard
//
//  Created by Cole Kauppinen on 10/21/21.
//

import Foundation

class Game {
    
    var gameId: String
    var arena: String
    var clock: String
    var period: String
    var gameStatus: Int
    
    var awayScore: String
    var awayTeamId: String
    var homeScore: String
    var homeTeamId: String

    
    //Creates a pizza with the corresponding ingredients and specifications
    init(gameId:String, arena:String, clock:String, period:String, gameStatus:Int, awayScore:String, awayTeamId:String, homeScore:String, homeTeamId:String){
        self.gameId = gameId
        self.arena = arena
        self.clock = clock
        self.period = period
        self.gameStatus = gameStatus
        self.awayScore = awayScore
        self.awayTeamId = awayTeamId
        self.homeScore = homeScore
        self.homeTeamId = homeTeamId
    }
}
