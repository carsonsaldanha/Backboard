//
//  PlayerViewController.swift
//  Backboard
//
//  Created by Cole Kauppinen on 11/4/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class PlayerViewController: UIViewController {
    
    var playerID = String()
    var playerData: JSON = JSON()

    @IBOutlet weak var playerHeader: PlayerPageHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeader()
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
