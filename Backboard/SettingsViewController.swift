//
//  SettingsViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase
import DLRadioButton

class SettingsViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favoriteTeamLabel: UILabel!
    var currentView: UIUserInterfaceStyle!
    var updateView: UIUserInterfaceStyle!
    var pressedSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Design for the saveButton
        saveButton.backgroundColor = UIColor.init(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
        saveButton.layer.cornerRadius = 25.0
        saveButton.tintColor = UIColor.white
        
        // Design for the signout button
        signOutButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        signOutButton.layer.cornerRadius = 25.0
        signOutButton.tintColor = UIColor.white
        
        //get and output display the favorite team
        emailLabel.text! = (Auth.auth().currentUser?.email)!
        
        let defaults = UserDefaults.standard
        let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
        
        favoriteTeamLabel.text! = retrievedFavoriteTeam!
        
        //adds the lines dynamically
        let lineView = UIView(frame: CGRect(x: 20, y: 190, width: 390, height: 1))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView)
        
        let lineView2 = UIView(frame: CGRect(x: 20, y: 235, width: 390, height: 1))
        lineView2.layer.borderWidth = 1.0
        lineView2.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView2)
        
        let lineView3 = UIView(frame: CGRect(x: 20, y: 285, width: 390, height: 1))
        lineView3.layer.borderWidth = 1.0
        lineView3.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView3)
        
        let lineView4 = UIView(frame: CGRect(x: 87, y: 340, width: 325, height: 1))
        lineView4.layer.borderWidth = 1.0
        lineView4.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView4)
        
        let lineView5 = UIView(frame: CGRect(x: 87, y: 390, width: 325, height: 1))
        lineView5.layer.borderWidth = 1.0
        lineView5.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView5)
        
        let lineView6 = UIView(frame: CGRect(x: 87, y: 440, width: 325, height: 1))
        lineView6.layer.borderWidth = 1.0
        lineView6.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView6)
        
        let lineView7 = UIView(frame: CGRect(x: 20, y: 490, width: 390, height: 1))
        lineView7.layer.borderWidth = 1.0
        lineView7.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView7)
        
        let lineView8 = UIView(frame: CGRect(x: 87, y: 545, width: 325, height: 1))
        lineView8.layer.borderWidth = 1.0
        lineView8.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView8)
        
        let lineView9 = UIView(frame: CGRect(x: 87, y: 595, width: 325, height: 1))
        lineView9.layer.borderWidth = 1.0
        lineView9.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(lineView9)
        
        //returns and stores the current display mode of the phone
        var osTheme: UIUserInterfaceStyle {
            return UIScreen.main.traitCollection.userInterfaceStyle
        }
        currentView = osTheme
    }
    
    //change the current view controller to the phone's current mode
    @IBAction func pressedSystemButton(_ sender: Any) {
        var osTheme: UIUserInterfaceStyle {
            return UIScreen.main.traitCollection.userInterfaceStyle
        }
        
        updateView = osTheme
    }
    
    //change the current view controller to light mode
    @IBAction func pressedLightButton(_ sender: Any) {
        updateView = .light
    }
    
    //change current view controller to dark mode
    @IBAction func pressedDarkButton(_ sender: Any) {
        updateView = .dark
    }
    
    //notifications for all teams
    @IBAction func pressedAllTeams(_ sender: Any) {
        
    }
    
    //notifications for our favorite team only
    @IBAction func pressedFavoriteTeam(_ sender: Any) {
        
    }
    
    //save changes if we press the save button
    @IBAction func pressedSaveButton(_ sender: Any) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = updateView
        }
        currentView = updateView
        pressedSave = true
    }
    
    //log out if we press the sign out button
    @IBAction func presssedSignOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(identifier: "LogInController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
        }
        catch {
            print("Error, Cannot sign out")
        }
    }
    
    //when changing view controllers, check if we saved our changes
    //if we did, nothing happens
    //if we didn't, revert to original settings
    override func viewWillDisappear(_ animated: Bool) {
        if !pressedSave {
            overrideUserInterfaceStyle = currentView
            updateView = currentView
        }
        pressedSave = false
    }
}
