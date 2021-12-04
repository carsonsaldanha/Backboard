//
//  FormattingMethods.swift
//  Backboard
//
//  Created by Cole Kauppinen on 11/16/21.
//

// Contains various methods used for formatting/displaying info throughout Backboard

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

// Returns the game quarter/period depending on its current status
func formatGamePeriod(gameData: JSON) -> String {
    if gameData["statusNum"].intValue != 2 || gameData["period"]["isHalftime"].boolValue {
        return ""
    }
    return "Q" + gameData["period"]["current"].stringValue
}

// Changes the tab bar and calendar accent color to fit the favorite team's color scheme
func formatTeamColors() {
    let defaults = UserDefaults.standard
    let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
    let hexCode = teamHexCodes[retrievedFavoriteTeam ?? "None"]
    let primaryHex = hexCode!.0
    let secondaryHex = hexCode!.1
    let primaryColor = UIColor.init(red: CGFloat(Double(primaryHex.0)/255), green: CGFloat(Double(primaryHex.1)/255), blue: CGFloat(Double(primaryHex.2)/255), alpha: 1)
    let secondaryColor = UIColor.init(red: CGFloat(Double(secondaryHex.0)/255), green: CGFloat(Double(secondaryHex.1)/255), blue: CGFloat(Double(secondaryHex.2)/255), alpha: 1)
    
    UIDatePicker.appearance().tintColor = primaryColor
    UITabBar.appearance().tintColor = primaryColor
    UITabBar.appearance().unselectedItemTintColor = secondaryColor
}
