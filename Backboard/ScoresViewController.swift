//
//  ScoresViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ScoresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var awayLogo: UIImageView!
    @IBOutlet weak var homeLogo: UIImageView!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var arenaName: UILabel!
    
}

class ScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scoresTableView: UITableView!
    
    var gamesList: [Game] = []
    let scoreCellIdentifier = "Scores Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        fetchGames()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: scoreCellIdentifier, for: indexPath) as! ScoresTableViewCell
        let row = indexPath.row
        
        cell.awayScore?.text = gamesList[row].awayScore
        cell.homeScore?.text = gamesList[row].homeScore
        cell.arenaName?.text = gamesList[row].arena

        let awayLogoURL = "https://cdn.nba.com/logos/nba/" + gamesList[row].awayTeamId + "/primary/L/logo.svg"
        let awayURL = URL(string: awayLogoURL)
        let awayData = try? Data(contentsOf: awayURL!)
        cell.awayLogo.image = UIImage(data: awayData!)
        
        let homeLogoURL = "https://cdn.nba.com/logos/nba/" + gamesList[row].homeTeamId + "/primary/L/logo.svg"
        let homeURL = URL(string: homeLogoURL)
        let homeData = try? Data(contentsOf: homeURL!)
        cell.homeLogo.image = UIImage(data: homeData!)
        
        return cell
    }

    func fetchGames() {
        let requestURL = "https://data.nba.net/data/10s/prod/v1/20211019//scoreboard.json"
        
        AF.request(requestURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let gamesData = JSON(value)
                for game in 0...gamesData["numGames"].intValue - 1 {
                    let gameData = gamesData["games"][game]

                    let idInfo = gameData["gameId"].stringValue
                    let arenaInfo = gameData["arena"]["name"].stringValue
                    let clockInfo = gameData["clock"].stringValue
                    let periodInfo = gameData["period"]["current"].stringValue
                    let statusInfo = gameData["statusNum"].intValue
                    
                    let awayScoreInfo = gameData["vTeam"]["score"].stringValue
                    let awayTeamInfo = gameData["vTeam"]["teamId"].stringValue
                    let homeScoreInfo = gameData["hTeam"]["score"].stringValue
                    let homeTeamInfo = gameData["hTeam"]["teamId"].stringValue

                    let singleGame:Game = Game(gameId: idInfo, arena: arenaInfo, clock: clockInfo, period: periodInfo, gameStatus: statusInfo, awayScore: awayScoreInfo, awayTeamId: awayTeamInfo, homeScore: homeScoreInfo, homeTeamId: homeTeamInfo)

                    self.gamesList.append(singleGame)
                }
            case .failure(let error):
                print(error)
            }
            // Reload the table after the API request is compelete
            DispatchQueue.main.async {
                self.scoresTableView.reloadData()
            }
        }
    }
    
    private func getTodaysDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        return format.string(from: date)
    }
}
