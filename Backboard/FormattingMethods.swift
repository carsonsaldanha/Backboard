//
//  FormattingMethods.swift
//  Backboard
//
//  Created by Cole Kauppinen on 11/16/21.
//

import Foundation
import SwiftyJSON

// Helper function to get today's date for the news API
func getTodaysDate() -> String {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format.string(from: date)
}

// Helper function to get today's date for updated game info
func formatDate(date: Date) -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyyMMdd"
    return format.string(from: date)
}

// Helper function to convert UTC time to the user's local time zone
func convertUTCtoLocal(utcTime: String) -> String {
    // Create dateFormatter with UTC time format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let date = dateFormatter.date(from: utcTime)
    // Convert to local time based on specified format
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.timeZone = NSTimeZone.local
    return dateFormatter.string(from: date!)
}

// Formats a ranking from a given number
func formatRank(rank: String) -> String{
    if rank.hasSuffix("1") && !rank.hasSuffix("11"){
        return rank + "st"
    }
    else if rank.hasSuffix("2") && !rank.hasSuffix("12"){
        return rank + "nd"
    }
    else if rank.hasSuffix("3") && !rank.hasSuffix("13"){
        return rank + "rd"
    }
    else{
        return rank + "th"
    }
}

// Returns the clock text depending on if the game status
func formatGameClock(gameData: JSON) -> String {
    switch gameData["statusNum"].intValue{
    case 1:
        return convertUTCtoLocal(utcTime: gameData["startTimeUTC"].stringValue)
    case 2:
        if (gameData["period"]["isHalftime"].boolValue) {
            return "HT"
        }
        else if (gameData["period"]["isEndOfPeriod"].boolValue) {
            return "EOQ"
        }
        else {
            return gameData["clock"].stringValue
        }
    default:
        return "Final"
    }
}

func formatGamePeriod(gameData: JSON) -> String {
    if gameData["statusNum"].intValue != 2 || gameData["period"]["isHalftime"].boolValue {
        return ""
    }
    return "Q" + gameData["period"]["current"].stringValue
}

// Changes the app accent color to the team's color
func formatTeamColors() {
    let defaults = UserDefaults.standard
    let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
    let hexCode = teamHexCodes[retrievedFavoriteTeam ?? "None"]
    let primaryColor = hexCode!.0
    let secondaryColor = hexCode!.1
    print(primaryColor)
    UIDatePicker.appearance().tintColor = UIColor.init(red: CGFloat(Double(primaryColor.0)/255), green: CGFloat(Double(primaryColor.1)/255), blue: CGFloat(Double(primaryColor.2)/255), alpha: 1)
    UITabBar.appearance().tintColor = UIColor.init(red: CGFloat(Double(primaryColor.0)/255), green: CGFloat(Double(primaryColor.1)/255), blue: CGFloat(Double(primaryColor.2)/255), alpha: 1)
    UITabBar.appearance().unselectedItemTintColor = UIColor.init(red: CGFloat(Double(secondaryColor.0)/255), green: CGFloat(Double(secondaryColor.1)/255), blue: CGFloat(Double(secondaryColor.2)/255), alpha: 1)
}

// RGB colors of each team
var teamHexCodes: [String : ((Int, Int, Int), (Int, Int, Int))] = [
    "Hawks": ((225, 68, 52), (196, 214, 0)),
    "Celtics": ((0, 122, 51), (139, 111, 78)),
    "Nets": ((112, 114, 113), (255, 255, 255)),
    "Hornets": ((29, 17, 96), (0, 120, 140)),
    "Bulls": ((206, 17, 65), (6, 25, 34)),
    "Cavaliers": ((134, 0, 56), (4, 30, 66)),
    "Mavericks": ((0, 83, 188), (0, 43, 92)),
    "Nuggets": ((13, 34, 64), (255, 198, 39)),
    "Pistons": ((200, 16, 46), (29,66,138)),
    "Warriors": ((29, 66, 138), (255, 199, 44)),
    "Rockets": ((206, 17, 65), (6,25,34)),
    "Pacers": ((0, 45, 98), (253, 187, 48)),
    "Clippers": ((200, 16, 46), (29,66,148)),
    "Lakers": ((85, 37, 130), (253, 185, 39)),
    "Grizzlies": ((93, 118, 169), (18, 23, 63)),
    "Heat": ((152, 0, 46), (249, 160, 27)),
    "Bucks": ((0, 71, 27), (180, 176, 158)),
    "Timberwolves": ((12, 35, 64), (35, 97, 146)),
    "Pelicans": ((0, 22, 65), (225, 58, 62)),
    "Knicks": ((0, 107, 182), (245, 132, 38)),
    "Thunder": ((0, 125, 195), (239, 59, 36)),
    "Magic": ((0, 125, 197), (196, 206, 211)),
    "76ers": ((0, 107, 182), (237, 23, 76)),
    "Suns": ((29, 17, 96), (229, 95, 32)),
    "Trail Blazers": ((224, 58, 62), (6, 25, 34)),
    "Kings": ((91, 43, 130), (99, 113, 122)),
    "Spurs": ((196, 206, 211), (6, 25, 34)),
    "Raptors": ((206, 17, 65), (6, 25, 34)),
    "Jazz": ((0, 43, 92), (0, 71, 27)),
    "Wizards": ((0, 43, 92), (227,24,55)),
    "None": ((231, 51, 55), (231, 51, 55))]
