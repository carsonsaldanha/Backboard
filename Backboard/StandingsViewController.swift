//
//  StandingsViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class StandingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seedingNumberLabel: UILabel!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var winRecordLabel: UILabel!
    @IBOutlet weak var lossRecordLabel: UILabel!
    @IBOutlet weak var gamesBehindLabel: UILabel!
    
}

struct Team {
    
    var name: String
    var teamID: String
    var winRecord: String
    var lossRecord: String
    var gamesBehind: String
    
}

class StandingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var conferenceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var standingsTableView: UITableView!
    
    let standingsCellIdentifier = "Standings Cell"
    var westStandings: [Team] = []
    var eastStandings: [Team] = []
    var westSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()        
        standingsTableView.delegate = self
        standingsTableView.dataSource = self
        fetchStandings()
    }
    
    // Upon the segement selected, sets the boolean to use for which conference should be displayed in the table
    @IBAction func onConferenceSegmentSelected(_ sender: Any) {
        switch conferenceSegmentedControl.selectedSegmentIndex {
        case 0:
            westSelected = true
        case 1:
            westSelected = false
        default:
            print("Error in conference segmented control")
        }
        standingsTableView.reloadData()
    }
    
    // Returns the number of teams in one conference (15)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return westStandings.count
    }
    
    // Sets the team seed, logo, name, record, and number of games behind for each cell in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: standingsCellIdentifier, for: indexPath) as! StandingsTableViewCell
        let row = indexPath.row
        cell.seedingNumberLabel?.text = "\(row + 1)"
        if (westSelected) {
            setCells(cell: cell, row: row, conferenceStandings: westStandings)
        } else {
            setCells(cell: cell, row: row, conferenceStandings: eastStandings)
        }
        return cell
    }
    
    // Pulls team standings from the NBA API and updates the table
    func fetchStandings() {
        let nbaStandingsAPI = "https://data.nba.net/data/10s/prod/v1/current/standings_conference.json"
        AF.request(nbaStandingsAPI, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseStandings(json: json["league"]["standard"]["conference"]["west"], conferenceStandings: &self.westStandings)
                self.parseStandings(json: json["league"]["standard"]["conference"]["east"], conferenceStandings: &self.eastStandings)
            case .failure(let error):
                print(error)
            }
            // Reload the table after the API request is compelete
            DispatchQueue.main.async {
                self.standingsTableView.reloadData()
            }
        }
    }
    
    // Sets a cell in the table with the name, logo, record, and number of games behind for a conference team
    private func setCells(cell: StandingsTableViewCell, row: Int, conferenceStandings: [Team]) {
        // Retrive the user's favorite team
        let defaults = UserDefaults.standard
        let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
        // If this cell is the user's favorite team, set all the labels to bold for better visibility
        if (conferenceStandings[row].name == retrievedFavoriteTeam) {
            cell.seedingNumberLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.teamNameLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.winRecordLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.lossRecordLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.gamesBehindLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        } else {
            cell.seedingNumberLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell.teamNameLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell.winRecordLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell.lossRecordLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell.gamesBehindLabel?.font = UIFont.systemFont(ofSize: 17.0)
        }
        
        cell.teamNameLabel?.text = conferenceStandings[row].name
        cell.teamLogoImageView?.image = UIImage(named: conferenceStandings[row].teamID)
        cell.winRecordLabel?.text = conferenceStandings[row].winRecord
        cell.lossRecordLabel?.text = conferenceStandings[row].lossRecord
        cell.gamesBehindLabel?.text = conferenceStandings[row].gamesBehind
    }
    
    // Helper function to parse the NBA standings API and append the data to the conference standings array
    private func parseStandings(json: JSON, conferenceStandings: inout [Team]) {
        // Parse the first 15 indicies because there are only 15 teams in a conference
        for teamIndex in 0...14 {
            if let name = json[teamIndex]["teamSitesOnly"]["teamNickname"].string {
                if let teamID = json[teamIndex]["teamId"].string {
                    if let wins = json[teamIndex]["win"].string {
                        if let losses = json[teamIndex]["loss"].string {
                            if let gamesBehind = json[teamIndex]["gamesBehind"].string {
                                let team = Team(name: name, teamID: teamID, winRecord: wins, lossRecord: losses, gamesBehind: gamesBehind)
                                conferenceStandings.append(team)
                            }
                        }
                    }
                }
            }
        }
    }

}

// Code from Merricat on Stack Overflow
class CustomSegmentedControl: UISegmentedControl {
    
    private let segmentInset: CGFloat = 5
    private let segmentImage: UIImage? = UIImage(color: UIColor.white)

    // Styles a segmented control to be oval shaped
    override func layoutSubviews(){
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
           let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height / 2
        }
    }
    
}

// Code from Merricat on Stack Overflow
extension UIImage {
    
    // Creates a UIImage given a UIColor
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}
