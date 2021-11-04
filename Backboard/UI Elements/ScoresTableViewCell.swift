//
//  ScoresTableViewCell.swift
//  Backboard
//
//  Created by Cole Kauppinen on 11/3/21.
//

import Foundation
import UIKit

class ScoresTableViewCell: UITableViewCell {
    

    @IBOutlet weak var awayLogo: UIButton!
    @IBOutlet weak var homeLogo: UIButton!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayRecord: UILabel!
    @IBOutlet weak var homeRecord: UILabel!
    
    @IBOutlet weak var arenaName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var attendance: UILabel!
    
    @IBOutlet weak var gameClock: UILabel!
}
