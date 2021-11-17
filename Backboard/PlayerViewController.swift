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
class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var playerID = String()
    var playerData: JSON = JSON()
    var playerStats: JSON = JSON()
    var currentStatList: [(String, String)] = []
    var careerStatList: [(String, String)] = []
    
    let seasonStatCellIdentifier = "Season Stat"
    let careerStatCellIdentifier = "Career Stat"

    @IBOutlet weak var playerHeader: PlayerPageHeader!
    @IBOutlet weak var seasonStatsTable: UITableView!
    @IBOutlet weak var careerStatsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seasonStatsTable.delegate = self
        seasonStatsTable.dataSource = self
        careerStatsTable.delegate = self
        careerStatsTable.dataSource = self
        loadHeader()
        loadPlayerStats()
    }
    
    // Fetches player photo and profile information and loads into display
    func loadHeader() {
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
        if playerData["draft"]["seasonYear"].stringValue != "" {
            playerHeader.playerDraft.text = "Drafted: " + playerData["draft"]["seasonYear"].stringValue +  " (Round " + playerData["draft"]["roundNum"].stringValue + ", Pick " + playerData["draft"]["pickNum"].stringValue + ")"
        } else {
            playerHeader.playerDraft.text = "Undrafted"
        }
       
        playerHeader.playerCountry.text = "Country: " + playerData["country"].stringValue
    }
    
    // Fetches player stats and appends to both statistics table view lists
    func loadPlayerStats() {
        let playerURL = "https://data.nba.net/data/10s/prod/v1/2021/players/" + playerID + "_profile.json"
        AF.request(playerURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.playerStats = JSON(value)["league"]["standard"]["stats"]
                self.loadStatData(statListIdentifer: "Current", statData: self.playerStats["latest"])
                self.loadStatData(statListIdentifer: "Career", statData: self.playerStats["careerSummary"])
                self.seasonStatsTable.reloadData()
                self.careerStatsTable.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Populates current stats table; uses tuples to allow for a formatted string for display
    func loadStatData(statListIdentifer: String, statData: JSON) {
        var statList: [(String, String)] = []
        statList.append(("PPG", statData["ppg"].stringValue))
        statList.append(("RPG", statData["rpg"].stringValue))
        statList.append(("APF", statData["apg"].stringValue))
        statList.append(("MPG", statData["mpg"].stringValue))
        statList.append(("SPG", statData["spg"].stringValue))
        statList.append(("BPG", statData["bpg"].stringValue))
        statList.append(("FTP", statData["ftp"].stringValue))
        statList.append(("FGP", statData["fgp"].stringValue))
        statList.append(("3PTP", statData["tpp"].stringValue))
        statList.append(("Points", statData["points"].stringValue))
        statList.append(("Assists", statData["assists"].stringValue))
        statList.append(("Rebounds", statData["totReb"].stringValue))
        statList.append(("Steals", statData["steals"].stringValue))
        statList.append(("Blocks", statData["blocks"].stringValue))
        statList.append(("Made Free Throws", statData["ftm"].stringValue))
        statList.append(("Made Field Goals", statData["fgm"].stringValue))
        statList.append(("Made Threes", statData["tpm"].stringValue))
        statList.append(("Offensive Rebounds", statData["offReb"].stringValue))
        statList.append(("Defensive Rebounds", statData["defReb"].stringValue))
        statList.append(("Turnovers", statData["turnovers"].stringValue))
        statList.append(("Games Played", statData["gamesPlayed"].stringValue))
        statList.append(("Minutes", statData["min"].stringValue))
        statList.append(("+/-", statData["plusMinus"].stringValue))
        if statListIdentifer == "Current" {
            currentStatList = statList
        } else {
            careerStatList = statList
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == seasonStatsTable ? currentStatList.count : careerStatList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let chosenList = tableView == seasonStatsTable ? currentStatList : careerStatList
        let chosenCell = tableView == seasonStatsTable ? seasonStatCellIdentifier : careerStatCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: chosenCell, for: indexPath) as! PlayerStatsCell

        cell.statName.text = chosenList[row].0
        cell.statValue.text = chosenList[row].1
        return cell
    }
}
