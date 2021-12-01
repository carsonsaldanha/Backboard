//
//  TeamViewController.swift
//  Backboard
//
//  Created by Cole Kauppinen on 11/4/21.
//

import UIKit
import Alamofire
import SwiftyJSON

// Represents a screen with detailed team information
class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var teamID = String()
    var teamInfoData:JSON = JSON()
    var teamRankData:JSON = JSON()
    var teamStandingData:JSON = JSON()
    var teamPlayerList: [JSON] = []
    var teamStatsList: [(String, JSON)] = []
    
    let rosterCellIdentifier = "Roster Cell"
    let statRankingCellIdentifier = "Stat Ranking"
    let playerSegueIdentifier = "Player Segue"

    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var statRankingsTableView: UITableView!
    @IBOutlet weak var teamHeader: TeamPageHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rosterTableView.delegate = self
        rosterTableView.dataSource = self
        statRankingsTableView.delegate = self
        statRankingsTableView.dataSource = self
        fetchTeam()
    }
    
    // Fetches team information, current standings, current roster, and team stats from API
    // Also loads visual data after data has been fetched
    func fetchTeam() {
        let infoURL = "https://data.nba.net/data/10s/prod/v1/2021/teams.json"
        AF.request(infoURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let teamList = JSON(value)["league"]["standard"]
                for teamIndex in 0...33{
                    if teamList[teamIndex]["teamId"].stringValue == self.teamID {
                        self.teamInfoData = teamList[teamIndex]
                        self.loadHeader()
                        break
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let rankingsURL = "https://data.nba.net/data/10s/prod/v1/2021/team_stats_rankings.json"
        AF.request(rankingsURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let ranksList = JSON(value)["league"]["standard"]["regularSeason"]["teams"]
                for rankIndex in 0...29{
                    if ranksList[rankIndex]["teamId"].stringValue == self.teamID {
                        self.teamRankData = ranksList[rankIndex]
                        self.loadStatRankings()
                        break
                    }
                }
                self.statRankingsTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        let standingsURL = "https://data.nba.net/data/10s/prod/v1/current/standings_all_no_sort_keys.json"
        AF.request(standingsURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let standingsList = JSON(value)["league"]["standard"]["teams"]
                for standingIndex in 0...29{
                    if standingsList[standingIndex]["teamId"].stringValue == self.teamID {
                        self.teamStandingData = standingsList[standingIndex]
                        self.loadStandings()
                        break
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let playersURL = "https://data.nba.net/data/10s/prod/v1/2021/players.json"
        AF.request(playersURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let playerList = JSON(value)["league"]["standard"].array
                for player in playerList!{
                    if(player["teamId"].stringValue == self.teamID){
                        self.teamPlayerList.append(player)
                    }
                }
                self.rosterTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Displays header info by loading from API
    func loadHeader() {
        teamHeader.teamLogo.image = UIImage(named: teamID)
        teamHeader.teamName.text = teamInfoData["fullName"].stringValue
        teamHeader.teamConf.text = teamInfoData["confName"].stringValue + "ern Conference"
        teamHeader.teamDiv.text = teamInfoData["divName"].stringValue + " Division"
    }
    
    // Displays standings info by loading from API
    func loadStandings() {
        let formattedConf = formatRank(rank: teamStandingData["confRank"].stringValue)
        let formattedDiv = formatRank(rank: teamStandingData["divRank"].stringValue)
        teamHeader.confRank.text = "(" + formattedConf + ")"
        teamHeader.divRank.text = "(" + formattedDiv + ")"
        teamHeader.teamRecord.text = teamStandingData["win"].stringValue + "-" + teamStandingData["loss"].stringValue
        teamHeader.teamWinPct.text = "WinPct: " + teamStandingData["winPct"].stringValue
        
        let streakType = teamStandingData["isWinStreak"].boolValue ? "W" : "L"
        teamHeader.teamStreak.text = "Streak: \(streakType)\(teamStandingData["streak"].stringValue)"
    }
    
    // Specifices table length for either roster or stats tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == rosterTableView ? teamPlayerList.count : teamStatsList.count)
    }
    
    // Displays corresponidng data for either roster or stats cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if tableView == rosterTableView {
            let playerCell = tableView.dequeueReusableCell(withIdentifier: rosterCellIdentifier, for: indexPath) as! RosterPlayerCell
            let playerPhotoUrl = NSURL(string: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/" + teamPlayerList[row]["personId"].stringValue + ".png")! as URL
            if let playerPhotoData: NSData = NSData(contentsOf: playerPhotoUrl) {
                playerCell.playerPhoto.image = UIImage(data : playerPhotoData as Data)
            }
            
            playerCell.playerName.text = teamPlayerList[row]["firstName"].stringValue + " " + teamPlayerList[row]["lastName"].stringValue
            playerCell.playerJersey.text = "#" + teamPlayerList[row]["jersey"].stringValue
            playerCell.playerPosition.text = teamPlayerList[row]["pos"].stringValue
            return playerCell
        } else {
            let statRankingCell = tableView.dequeueReusableCell(withIdentifier: statRankingCellIdentifier, for: indexPath) as! TeamRankingsCell
            statRankingCell.statName.text = teamStatsList[row].0
            statRankingCell.statAvg.text = teamStatsList[row].1["avg"].stringValue
            statRankingCell.statRank.text = formatRank(rank: teamStatsList[row].1["rank"].stringValue)
            return statRankingCell
        }
    }
    
    // Appends stat data for table view; includes a string for display formatting
    func loadStatRankings() {
        teamStatsList.append(("PPG", teamRankData["ppg"]))
        teamStatsList.append(("FGP", teamRankData["fgp"]))
        teamStatsList.append(("FTP", teamRankData["ftp"]))
        teamStatsList.append(("ORPG", teamRankData["orpg"]))
        teamStatsList.append(("DRPG", teamRankData["drpg"]))
        teamStatsList.append(("TRPG", teamRankData["trpg"]))
        teamStatsList.append(("APG", teamRankData["apg"]))
        teamStatsList.append(("TOVPG", teamRankData["tpg"]))
        teamStatsList.append(("SPG", teamRankData["spg"]))
        teamStatsList.append(("BPG", teamRankData["bpg"]))
        teamStatsList.append(("PFPG", teamRankData["pfpg"]))
        teamStatsList.append(("OppPPG", teamRankData["oppg"]))
        teamStatsList.append(("EFF", teamRankData["eff"]))
    }
    
    // Segues to Player VC based on roster table view selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == playerSegueIdentifier,
           let destination = segue.destination as? PlayerViewController,
           let playerIndex = rosterTableView.indexPathForSelectedRow?.row {
            destination.playerData = teamPlayerList[playerIndex]
            destination.playerID = teamPlayerList[playerIndex]["personId"].stringValue
        }
    }
}
