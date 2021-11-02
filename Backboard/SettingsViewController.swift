//
//  SettingsViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.backgroundColor = UIColor.init(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
        saveButton.layer.cornerRadius = 25.0
        saveButton.tintColor = UIColor.white
        
        signOutButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        signOutButton.layer.cornerRadius = 25.0
        signOutButton.tintColor = UIColor.white
        
        emailLabel.text! = (Auth.auth().currentUser?.email)!
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
