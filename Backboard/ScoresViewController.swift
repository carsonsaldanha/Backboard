//
//  ScoresViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scoresTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var gamesList: [JSON] = []
    var gameDate = Date()
    let scoreCellIdentifier = "Scores Cell"
    let gameSegueIdentifier = "Game Segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        fetchGames()
    }
    
    // Returns the number of games in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    // Sets the scores, team info, arena info, live game info, etc. for each cell in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: scoreCellIdentifier, for: indexPath) as! ScoresTableViewCell
        let row = indexPath.row
        
        cell.awayName?.text = gamesList[row]["vTeam"]["triCode"].stringValue
        cell.homeName?.text = gamesList[row]["hTeam"]["triCode"].stringValue
        cell.awayScore?.text = gamesList[row]["vTeam"]["score"].stringValue
        cell.homeScore?.text = gamesList[row]["hTeam"]["score"].stringValue
        cell.awayRecord?.text = gamesList[row]["vTeam"]["win"].stringValue + "-" + gamesList[row]["vTeam"]["loss"].stringValue
        cell.homeRecord?.text = gamesList[row]["hTeam"]["win"].stringValue + "-" + gamesList[row]["hTeam"]["loss"].stringValue
        
        cell.awayLogo.image = UIImage(named: gamesList[row]["vTeam"]["teamId"].stringValue)
        cell.homeLogo.image = UIImage(named: gamesList[row]["hTeam"]["teamId"].stringValue)
        
        cell.arenaName?.text = gamesList[row]["arena"]["name"].stringValue
        cell.location?.text = gamesList[row]["arena"]["city"].stringValue + ", " + gamesList[row]["arena"]["stateAbbr"].stringValue
        
        let clockText: String
        let attendanceText: String
        switch gamesList[row]["statusNum"].intValue{
        case 1:
            clockText = gamesList[row]["startTimeEastern"].stringValue
            attendanceText = "Pending"
        case 2:
            clockText = gamesList[row]["clock"].stringValue
            attendanceText = gamesList[row]["attendance"].stringValue
        default:
            clockText = "Final"
            attendanceText = gamesList[row]["attendance"].stringValue
        }
        
        cell.gameClock?.text = clockText
        cell.attendance?.text = "Attendance: " + attendanceText

        return cell
    }

    // Pulls NBA articles from the NBA data API and updates the table
    // Stores each game as a JSON since many variables within it will eventually need to be accessed
    func fetchGames() {
        let requestURL = "https://data.nba.net/data/10s/prod/v1/" + formatDate(date: gameDate) + "/scoreboard.json"
        
        AF.request(requestURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let gamesData = JSON(value)
                for game in 0..<gamesData["numGames"].intValue {
                    self.gamesList.append(gamesData["games"][game])
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
    
    // Helper function to get today's date for updated game info
    private func formatDate(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        return format.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == gameSegueIdentifier,
           let destination = segue.destination as? GameViewController,
           let gameIndex = scoresTableView.indexPathForSelectedRow?.row {
            destination.gameID = gamesList[gameIndex]["gameID"].stringValue
        }
    }
    
    @IBAction func selectDate(_ sender: Any) {
        gameDate = datePicker.date
        gamesList = []
        fetchGames()
        scoresTableView.reloadData()
    }
}
