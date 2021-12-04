//
//  GlobalTeamData.swift
//  Backboard
//
//  Created by Cole Kauppinen on 12/4/21.
//

// Global data structures containing team information used throughout Backboard

import Foundation

// List of NBA teams
let leagueTeams: [String] = ["None", "76ers", "Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers",
                       "Grizzlies", "Hawks", "Heat", "Hornets", "Jazz", "Kings",
                       "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets",
                       "Pacers", "Pelicans", "Pistons", "Raptors", "Rockets", "Spurs",
                       "Suns", "Thunder", "Timberwolves", "Trail Blazers", "Warriors", "Wizards"]

// Dicitonary mapping team abbreviations to full names
let teamNamesDictonary = [
    "ATL" : "Hawks",
    "BKN" : "Nets",
    "BOS" : "Celtics",
    "CHA" : "Hornets",
    "CHI" : "Bulls",
    "CLE" : "Cavaliers",
    "DAL" : "Mavericks",
    "DEN" : "Nuggets",
    "DET" : "Pistons",
    "GSW" : "Warriors",
    "HOU" : "Rockets",
    "IND" : "Pacers",
    "LAC" : "Clippers",
    "LAL" : "Lakers",
    "MEM" : "Grizzlies",
    "MIA" : "Heat",
    "MIL" : "Bucks",
    "MIN" : "Timberwolves",
    "NOP" : "Pelicans",
    "NYK" : "Knicks",
    "OKC" : "Thunder",
    "ORL" : "Magic",
    "PHI" : "76ers",
    "PHX" : "Suns",
    "POR" : "Trail Blazers",
    "SAC" : "Kings",
    "SAS" : "Spurs",
    "TOR" : "Raptors",
    "UTA" : "Jazz",
    "WAS" : "Wizards"
]

// RGB colors of eaach team's primary/secondary colors
var teamHexCodes: [String : ((Int, Int, Int), (Int, Int, Int))] = [
    "Hawks": ((225, 68, 52), (131, 143, 0)),
    "Celtics": ((0, 122, 51), (139, 111, 78)),
    "Nets": ((169, 169, 169), (105, 105, 105)),
    "Hornets": ((58, 34, 192), (0, 120, 140)),
    "Bulls": ((206, 17, 65), (105, 105, 105)),
    "Cavaliers": ((134, 0, 56), (253, 187, 48)),
    "Mavericks": ((0, 83, 188), (187, 196, 202)),
    "Nuggets": ((26, 68, 128), (255, 198, 39)),
    "Pistons": ((200, 16, 46), (29,66,138)),
    "Warriors": ((29, 66, 138), (255, 199, 44)),
    "Rockets": ((206, 17, 65), (196, 206, 211)),
    "Pacers": ((0, 68, 147), (253, 187, 48)),
    "Clippers": ((200, 16, 46), (29, 66, 148)),
    "Lakers": ((85, 37, 130), (253, 185, 39)),
    "Grizzlies": ((93, 118, 169), (36, 46, 126)),
    "Heat": ((152, 0, 46), (249, 160, 27)),
    "Bucks": ((0, 71, 27), (180, 176, 158)),
    "Timberwolves": ((24, 70, 128), (35, 97, 146)),
    "Pelicans": ((0, 44, 130), (225, 58, 62)),
    "Knicks": ((0, 107, 182), (245, 132, 38)),
    "Thunder": ((0, 125, 195), (239, 59, 36)),
    "Magic": ((0, 125, 197), (196, 206, 211)),
    "76ers": ((0, 107, 182), (237, 23, 76)),
    "Suns": ((44, 26, 144), (229, 95, 32)),
    "Trail Blazers": ((224, 58, 62), (105, 105, 105)),
    "Kings": ((91, 43, 130), (99, 113, 122)),
    "Spurs": ((196, 206, 211), (105, 105, 105)),
    "Raptors": ((206, 17, 65), (128, 128, 128)),
    "Jazz": ((249, 160, 27), (0, 71, 27)),
    "Wizards": ((0, 65, 138), (227,24,55)),
    "None": ((231, 51, 55), (231, 51, 55))]
