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
    var selectedTeamID = String()
    var changedDate = false
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
    
    let scoreCellIdentifier = "Scores Cell"
    let gameSegueIdentifier = "Game Segue"
    let awayTeamSegueIdentifier = "Away Team Segue"
    let homeTeamSegueIdentifier = "Home Team Segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDatePicker.appearance().tintColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        fetchGames()
    }
    
    // Returns the number of games in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    // Sets the scores, team info, live game info, etc. for each cell in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: scoreCellIdentifier, for: indexPath) as! ScoresTableViewCell
        let row = indexPath.row
        
        cell.awayName?.text = gamesList[row]["vTeam"]["triCode"].stringValue
        cell.homeName?.text = gamesList[row]["hTeam"]["triCode"].stringValue
        cell.awayScore?.text = gamesList[row]["vTeam"]["score"].stringValue
        cell.homeScore?.text = gamesList[row]["hTeam"]["score"].stringValue
        cell.awayRecord?.text = gamesList[row]["vTeam"]["win"].stringValue + "-" + gamesList[row]["vTeam"]["loss"].stringValue
        cell.homeRecord?.text = gamesList[row]["hTeam"]["win"].stringValue + "-" + gamesList[row]["hTeam"]["loss"].stringValue
        
        cell.awayLogo.setImage(UIImage(named: gamesList[row]["vTeam"]["teamId"].stringValue), for: .normal)
        cell.homeLogo.setImage(UIImage(named: gamesList[row]["hTeam"]["teamId"].stringValue), for: .normal)
        
        // Sets tags for images (which are buttons) to allow us to segue to team pages
        cell.awayLogo.tag = row
        cell.homeLogo.tag = row
                
        let clockText: String
        switch gamesList[row]["statusNum"].intValue{
        case 1:
            clockText = convertUTCtoLocal(utcTime: gamesList[row]["startTimeUTC"].stringValue)
        case 2:
            clockText = gamesList[row]["clock"].stringValue
        default:
            clockText = "Final"
        }
        
        cell.gameClock?.text = clockText

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
                if (!self.changedDate) {
                    self.pushNotification()
                }
            }
        }
    }
    
    // Sends a notification at 5:00 PM with the details for the game of the user's favorite team
    func pushNotification() {
        let defaults = UserDefaults.standard
        let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
        let retrievedNotificationState = defaults.bool(forKey: "notifications")
        var hasGame = false
        var awayTeam = ""
        var homeTeam = ""
        var gameTime = ""
        var tvChannel = ""
        // Proceed if the user has granted notifications
        if (retrievedNotificationState == true) {
            // Check if the user's favorite team is playing today and store the game details
            for game in 0..<gamesList.count {
                awayTeam = teamNamesDictonary[gamesList[game]["vTeam"]["triCode"].stringValue] ?? ""
                homeTeam = teamNamesDictonary[gamesList[game]["hTeam"]["triCode"].stringValue] ?? ""
                if (awayTeam == retrievedFavoriteTeam || homeTeam == retrievedFavoriteTeam) {
                    hasGame = true
                    gameTime = convertUTCtoLocal(utcTime: gamesList[game]["startTimeUTC"].stringValue)
                    tvChannel = gamesList[game]["watch"]["broadcast"]["broadcasters"]["national"][0]["shortName"].stringValue
                    break
                }
            }
            // If the user's favorite team is playing today, we should send a notification
            if (hasGame) {
                // Create an object that holds the data for our notification
                let notification = UNMutableNotificationContent()
                notification.title = "\(awayTeam) @ \(homeTeam)"
                notification.subtitle = gameTime
                notification.body = tvChannel
                
                // Trigger the notification at 5:00 PM
                let gregorian = Calendar(identifier: .gregorian)
                let now = Date()
                var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                components.hour = 17
                components.minute = 0
                components.second = 0
                let date = gregorian.date(from: components)!
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                
                // Set up a request to tell iOS to submit the notification with that trigger
                let request = UNNotificationRequest(identifier: "notificationId",
                                                    content: notification,
                                                    trigger: notificationTrigger)
                
                // Submit the request to iOS
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Request error: ", error as Any)
                    } else {
                        print("Submitted notification")
                    }
                }
            }
        }
    }
    
    // Helper function to get today's date for updated game info
    private func formatDate(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        return format.string(from: date)
    }
    
    // Helper function to convert UTC time to the user's local time zone
    private func convertUTCtoLocal(utcTime: String) -> String {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == gameSegueIdentifier,
           let destination = segue.destination as? GameViewController,
           let gameIndex = scoresTableView.indexPathForSelectedRow?.row {
            destination.gameID = gamesList[gameIndex]["gameId"].stringValue
            destination.gameDate = formatDate(date: gameDate)
        }
        // Segues to team pages based on chosen team
        else if segue.identifier == awayTeamSegueIdentifier,
            let destination = segue.destination as? TeamViewController,
            let tappedButton = sender as? UIButton {
            destination.teamID = gamesList[tappedButton.tag]["vTeam"]["teamId"].stringValue
        }
        else if segue.identifier == homeTeamSegueIdentifier,
            let destination = segue.destination as? TeamViewController,
            let tappedButton = sender as? UIButton {
            destination.teamID = gamesList[tappedButton.tag]["hTeam"]["teamId"].stringValue
        }
    }
    
    @IBAction func selectDate(_ sender: Any) {
        gameDate = datePicker.date
        gamesList = []
        changedDate = true
        fetchGames()
    }

}
