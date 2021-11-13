//
//  PlayerViewController.swift
//  Backboard
//
//  Created by Cole Kauppinen on 11/4/21.
//

import UIKit
import Alamofire
import SwiftyJSON

// Represents a screen displaying detailed player informaiton
class PlayerViewController: UIViewController {
    
    var playerID = String()
    var playerData: JSON = JSON()
    var playerStats: JSON = JSON()
    var currentStatList: [(String, String)] = []
    var careerStatList: [(String, String)] = []

    @IBOutlet weak var playerHeader: PlayerPageHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeader()
        loadPlayerStats()
    }
    
    // Fetches player photo and profile information and loads into display
    func loadHeader() {
        print(playerID)
        let playerPhotoUrl = NSURL(string: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/" + playerID + ".png")! as URL
        if let playerPhotoData: NSData = NSData(contentsOf: playerPhotoUrl) {
            playerHeader.playerPhoto.image = UIImage(data : playerPhotoData as Data)
        }
        
        playerHeader.playerName.text = playerData["firstName"].stringValue + " " + playerData["lastName"].stringValue
        playerHeader.playerTeam.image = UIImage(named: playerData["teamId"].stringValue)
        playerHeader.playerJersey.text = "#" +  playerData["jersey"].stringValue
        playerHeader.playerPos.text = playerData["pos"].stringValue
        playerHeader.playerHeight.text = "Hgt: " + playerData["heightFeet"].stringValue + "'" + playerData["heightInches"].stringValue + "''"
        playerHeader.playerWeight.text = "Wt: " + playerData["weightPounds"].stringValue + " lbs."
        playerHeader.playerDraft.text = "Drafted: " + playerData["draft"]["seasonYear"].stringValue +  " (Round " + playerData["draft"]["roundNum"].stringValue + ", Pick " + playerData["draft"]["pickNum"].stringValue + ")"
        playerHeader.playerCountry.text = "Country: " + playerData["country"].stringValue
    }
    
    // Fetches player stats and appends to both statistics table view lists
    func loadPlayerStats() {
        let playerURL = "https://data.nba.net/data/10s/prod/v1/2021/players/" + playerID + "_profile.json"
        AF.request(playerURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.playerStats = JSON(value)["league"]["standard"]["stats"]
                self.loadCurrentStats()
                self.loadCareerStats()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Populates current stats table; uses tuples to allow for a formatted string for display
    func loadCurrentStats() {
        let currentStatData = playerStats["latest"]
        currentStatList.append(("PPG", currentStatData["ppg"].stringValue))
        currentStatList.append(("RPG", currentStatData["rpg"].stringValue))
        currentStatList.append(("APF", currentStatData["apg"].stringValue))
        currentStatList.append(("MPG", currentStatData["mpg"].stringValue))
        currentStatList.append(("TOVPG", currentStatData["topg"].stringValue))
        currentStatList.append(("SPG", currentStatData["spg"].stringValue))
        currentStatList.append(("BPG", currentStatData["bpg"].stringValue))
        currentStatList.append(("FTP", currentStatData["ftp"].stringValue))
        currentStatList.append(("FGP", currentStatData["fgp"].stringValue))
        currentStatList.append(("Points", currentStatData["points"].stringValue))
        currentStatList.append(("Assists", currentStatData["assists"].stringValue))
        currentStatList.append(("Rebounds", currentStatData["totReb"].stringValue))
        currentStatList.append(("Steals", currentStatData["steals"].stringValue))
        currentStatList.append(("Blocks", currentStatData["blocks"].stringValue))
        currentStatList.append(("Offensive Rebounds", currentStatData["offReb"].stringValue))
        currentStatList.append(("Defensive Rebounds", currentStatData["defReb"].stringValue))
        currentStatList.append(("Games Played", currentStatData["gamesPlayed"].stringValue))
        currentStatList.append(("+/-", currentStatData["plusMinus"].stringValue))
        currentStatList.append(("Minutes", currentStatData["min"].stringValue))
    }
    
    // Populates career stats table; uses tuples to allow for a formatted string for display
    func loadCareerStats() {
        
    }
}
