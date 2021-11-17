//
//  GameViewController.swift
//  Backboard
//
//  Created by Cole Kauppinen on 11/3/21.
//

import UIKit
import Alamofire
import SwiftyJSON

// Represents a detailed screen of game info
class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameID = String()
    var gameDate = String()
    var gameData:JSON = JSON()
    var leaderStat = "points"
    
    var awayStats:[(String, JSON)] = []
    var homeStats:[(String, JSON)] = []
    
    @IBOutlet weak var awayStatsLogo: UIButton!
    @IBOutlet weak var homeStatsLogo: UIButton!
    
    let quartersCellIdentifier = "Quarter Cell"
    let teamStatsCellIdentifier = "Team Stats Cell"
    let awayTeamSegueIdentifier = "Away Team Segue"
    let homeTeamSegueIdentifier = "Home Team Segue"

    @IBOutlet weak var gameHeader: GamePageHeader!
    @IBOutlet weak var quartersTableView: UITableView!
    @IBOutlet weak var teamStatsTableView: UITableView!
    @IBOutlet weak var teamLeaders: TeamLeaderView!
    @IBOutlet weak var teamLeaderSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quartersTableView.delegate = self
        quartersTableView.dataSource = self
        teamStatsTableView.delegate = self
        teamStatsTableView.dataSource = self
        fetchGame()
    }
    
    // Fetches game JSON and calls corresponding load methods
    func fetchGame() {
        let requestURL = "https://data.nba.net/data/10s/prod/v1/" + gameDate + "/" + gameID + "_boxscore.json"
        AF.request(requestURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.gameData = JSON(value)
                self.loadHeader()
                self.loadLeaders()
                self.loadTeamStats(chosenTeam: "vTeam")
                self.loadTeamStats(chosenTeam: "hTeam")
                self.teamStatsTableView.reloadData()
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.quartersTableView.reloadData()
            }
        }
    }
    
    // Sets length for either the quarter table or statistics table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == quartersTableView ? 2 : awayStats.count)
    }
    
    // Fills out either quarter table cells or team stats cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if tableView == quartersTableView {
            let quarterCell = tableView.dequeueReusableCell(withIdentifier: quartersCellIdentifier, for: indexPath) as! QuarterScoresCell
            let chosenTeam = row == 0 ? "vTeam" : "hTeam"
            let gameInfo = gameData["basicGameData"]
            let scoresInfo = gameInfo[chosenTeam]["linescore"]
            
            // Sets quarter score values
            quarterCell.firstScore.text = scoresInfo[0]["score"].stringValue
            quarterCell.secondScore.text = scoresInfo[1]["score"].stringValue
            quarterCell.thirdScore.text = scoresInfo[2]["score"].stringValue
            quarterCell.fourthScore.text = scoresInfo[3]["score"].stringValue
            quarterCell.totalScore.text = gameInfo[chosenTeam]["score"].stringValue
            quarterCell.teamName.text = gameInfo[chosenTeam]["triCode"].stringValue
            quarterCell.teamLogo.image = UIImage(named: gameInfo[chosenTeam]["teamId"].stringValue)
            return quarterCell
        } else {
            let teamStatsCell = tableView.dequeueReusableCell(withIdentifier: teamStatsCellIdentifier, for: indexPath) as! TeamStatsCell
            teamStatsCell.statLabel.text = awayStats[row].0
            teamStatsCell.awayTeamValue.text = awayStats[row].1.stringValue
            teamStatsCell.homeTeamValue.text = homeStats[row].1.stringValue
            return teamStatsCell
        }
    }
    
    // Sets the leaderStatistic value based on segment selection; reloads game leader info from API
    @IBAction func selectedLeaderStat(_ sender: Any) {
        switch teamLeaderSegment.selectedSegmentIndex {
        case 0:
            leaderStat = "points"
        case 1:
            leaderStat = "rebounds"
        case 2:
            leaderStat = "assists"
        default:
            leaderStat = "Hesi pullup jimbos"
        }
        loadLeaders()
    }
    
    // Loads all header data from game JSON
    func loadHeader() {
        let gameInfo = gameData["basicGameData"]
        
        gameHeader.awayName.text = gameInfo["vTeam"]["triCode"].stringValue
        gameHeader.homeName.text = gameInfo["hTeam"]["triCode"].stringValue
        
        gameHeader.awayRecord.text = gameInfo["vTeam"]["win"].stringValue + "-" + gameInfo["vTeam"]["loss"].stringValue
        gameHeader.homeRecord.text = gameInfo["hTeam"]["win"].stringValue + "-" + gameInfo["hTeam"]["loss"].stringValue
        
        gameHeader.awayScore.text = gameInfo["vTeam"]["score"].stringValue
        gameHeader.homeScore.text = gameInfo["hTeam"]["score"].stringValue
        
        gameHeader.clock.text = formatGameClock(gameData: gameInfo)
        gameHeader.period.text = formatGamePeriod(gameData: gameInfo)
        
        gameHeader.arena.text = gameInfo["arena"]["name"].stringValue
        gameHeader.attendance.text = (gameInfo["attendance"] == "" || gameInfo["attendance"] == "0") ? "Attendance: Pending" : "Attendance: " + gameInfo["attendance"].stringValue
        
        gameHeader.awayLogo.setImage(UIImage(named: gameInfo["vTeam"]["teamId"].stringValue), for: .normal)
        gameHeader.homeLogo.setImage(UIImage(named: gameInfo["hTeam"]["teamId"].stringValue), for: .normal)
        
        awayStatsLogo.setImage(UIImage(named: gameInfo["vTeam"]["teamId"].stringValue), for: .normal)
        homeStatsLogo.setImage(UIImage(named: gameInfo["hTeam"]["teamId"].stringValue), for: .normal)
    }
    
    // Loads all header data from game JSON
    func loadLeaders(){
        let statInfo = gameData["stats"]
        let awayPlayer = statInfo["vTeam"]["leaders"][leaderStat]["players"][0]
        let homePlayer = statInfo["hTeam"]["leaders"][leaderStat]["players"][0]
        
        let awayPhotoUrl = NSURL(string: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/" + awayPlayer["personId"].stringValue + ".png")! as URL
        if let awayPhotoData: NSData = NSData(contentsOf: awayPhotoUrl) {
            teamLeaders.awayPlayerPhoto.image = UIImage(data : awayPhotoData as Data)
        }
        
        let homePhotoUrl = NSURL(string: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/" + homePlayer["personId"].stringValue + ".png")! as URL
        if let homePhotoData: NSData = NSData(contentsOf: homePhotoUrl) {
            teamLeaders.homePlayerPhoto.image = UIImage(data : homePhotoData as Data)
        }
        
        teamLeaders.awayPlayerName.text = awayPlayer["firstName"].stringValue + " " + awayPlayer["lastName"].stringValue
        teamLeaders.homePlayerName.text = homePlayer["firstName"].stringValue + " " + homePlayer["lastName"].stringValue
        
        teamLeaders.awayPlayerValue.text = statInfo["vTeam"]["leaders"][leaderStat]["value"].stringValue
        teamLeaders.homePlayerValue.text = statInfo["hTeam"]["leaders"][leaderStat]["value"].stringValue
    }
    
    // Loads team stats for home/away teams as well as a formatted string for display
    func loadTeamStats(chosenTeam: String) {
        var statList: [(String, JSON)] = []
        let teamStatInfo = gameData["stats"][chosenTeam]
        
        statList.append(("PTS", teamStatInfo["totals"]["points"]))
        statList.append(("FGM", teamStatInfo["totals"]["fgm"]))
        statList.append(("FGA", teamStatInfo["totals"]["fga"]))
        statList.append(("FGP", teamStatInfo["totals"]["fgp"]))
        statList.append(("FTM", teamStatInfo["totals"]["ftm"]))
        statList.append(("FTA", teamStatInfo["totals"]["fta"]))
        statList.append(("FTP", teamStatInfo["totals"]["ftp"]))
        statList.append(("OFF REB", teamStatInfo["totals"]["offReb"]))
        statList.append(("DEF REB", teamStatInfo["totals"]["defReb"]))
        statList.append(("TOT REB", teamStatInfo["totals"]["totReb"]))
        statList.append(("AST", teamStatInfo["totals"]["assists"]))
        statList.append(("PF", teamStatInfo["totals"]["pFouls"]))
        statList.append(("STL", teamStatInfo["totals"]["steals"]))
        statList.append(("TOV", teamStatInfo["totals"]["turnovers"]))
        statList.append(("BLK", teamStatInfo["totals"]["blocks"]))
        statList.append(("+/-", teamStatInfo["totals"]["plusMinus"]))
        statList.append(("Short Timeouts Left", teamStatInfo["totals"]["short_timeout_remaining"]))
        statList.append(("Full Timeouts Left", teamStatInfo["totals"]["full_timeout_remaining"]))
        statList.append(("Fast Break Pts", teamStatInfo["fastBreakPoints"]))
        statList.append(("Pts in Paint", teamStatInfo["pointsInPaint"]))
        statList.append(("Largest Lead", teamStatInfo["biggestLead"]))
        statList.append(("Second Chance Pts", teamStatInfo["secondChancePoints"]))
        statList.append(("Pts off TOV", teamStatInfo["pointsOffTurnovers"]))
        statList.append(("Longest Run", teamStatInfo["longestRun"]))
        
        if chosenTeam == "vTeam"{
            awayStats = statList
        }else {
            homeStats = statList
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == awayTeamSegueIdentifier,
           let destination = segue.destination as? TeamViewController {
            destination.teamID = gameData["basicGameData"]["vTeam"]["teamId"].stringValue
        }
        else if segue.identifier == homeTeamSegueIdentifier,
            let destination = segue.destination as? TeamViewController {
             destination.teamID = gameData["basicGameData"]["hTeam"]["teamId"].stringValue
        }
    }
}
