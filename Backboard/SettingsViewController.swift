//
//  SettingsViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase
import DLRadioButton

class SettingsViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favoriteTeamLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var systemButton: DLRadioButton!
    @IBOutlet weak var lightButton: DLRadioButton!
    @IBOutlet weak var darkButton: DLRadioButton!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    var currentView: UIUserInterfaceStyle!
    var updateView: UIUserInterfaceStyle!
    var pressedSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        // Design for the signout button
        signOutButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        signOutButton.layer.cornerRadius = 25.0
        signOutButton.tintColor = UIColor.white
        
        // Get and display the favorite team and account email
        emailLabel.text! = (Auth.auth().currentUser?.email)!
        
        let defaults = UserDefaults.standard
        let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
        favoriteTeamLabel.text? = retrievedFavoriteTeam ?? "None"
        
        let screenWidth = UIScreen.main.bounds.width
        
        // Adds the lines dynamically
        let lineView = UIView(frame: CGRect(x: 20, y: emailLabel.center.y + 26, width: screenWidth - 40, height: 1))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
        
        let lineView2 = UIView(frame: CGRect(x: 20, y: favoriteTeamLabel.center.y + 26, width: screenWidth - 40, height: 1))
        lineView2.layer.borderWidth = 1.0
        lineView2.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView2)
        
        let lineView3 = UIView(frame: CGRect(x: 20, y: themeLabel.center.y + 26, width: screenWidth - 40, height: 1))
        lineView3.layer.borderWidth = 1.0
        lineView3.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView3)
        
        let lineView4 = UIView(frame: CGRect(x: 87, y: systemButton.center.y + 26, width: screenWidth - 107, height: 1))
        lineView4.layer.borderWidth = 1.0
        lineView4.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView4)
        
        let lineView5 = UIView(frame: CGRect(x: 87, y: lightButton.center.y + 26, width: screenWidth - 107, height: 1))
        lineView5.layer.borderWidth = 1.0
        lineView5.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView5)
        
        let lineView6 = UIView(frame: CGRect(x: 87, y: darkButton.center.y + 26, width: screenWidth - 107, height: 1))
        lineView6.layer.borderWidth = 1.0
        lineView6.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView6)
        
        //check user defaults to see if notifications were enabled
        let retrievedNotificationState = defaults.bool(forKey: "notifications")
        if (retrievedNotificationState == false) {
            notificationsSwitch.isOn = false
        } else {
            notificationsSwitch.isOn = true
        }
        
        //check user defaults to see the phone's current display mode
        //select and deselect the buttons according to the setting
        let currentMode = defaults.integer(forKey: "mode")
        if currentMode == 0 {
            systemButton.isSelected = true
            lightButton.isSelected = false
            darkButton.isSelected = false
        }
        else if currentMode == 1 {
            systemButton.isSelected = false
            lightButton.isSelected = true
            darkButton.isSelected = false
        }
        else {
            systemButton.isSelected = false
            lightButton.isSelected = false
            darkButton.isSelected = true
        }
    }
    
    //change the current view controller to the phone's current mode
    @IBAction func pressedSystemButton(_ sender: Any) {
        var osTheme: UIUserInterfaceStyle {
            return UIScreen.main.traitCollection.userInterfaceStyle
        }
        
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = osTheme
        }
        
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "mode")
        
        systemButton.isSelected = true
        lightButton.isSelected = false
        darkButton.isSelected = false
    }
    
    //change the app to light mode
    @IBAction func pressedLightButton(_ sender: Any) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
        
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "mode")
        
        systemButton.isSelected = false
        lightButton.isSelected = true
        darkButton.isSelected = false
    }
    
    //change the app to dark mode
    @IBAction func pressedDarkButton(_ sender: Any) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
        
        let defaults = UserDefaults.standard
        defaults.set(2, forKey: "mode")
        
        systemButton.isSelected = false
        lightButton.isSelected = false
        darkButton.isSelected = true
    }
    
    // Update the notification user default state to set the toggle based on it
    @IBAction func notificationsSwitchToggled(_ sender: Any) {
        if (notificationsSwitch.isOn) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert]) { (granted, error) in
                if granted {
                    UserDefaults.standard.set(true, forKey: "notifications")
                    print("Permission was granted.")
                } else {
                    UserDefaults.standard.set(false, forKey: "notifications")
                    DispatchQueue.main.async {
                        self.notificationsSwitch.isOn = false
                    }
                    print("Permission was denied or there was an error: ", error as Any)
                }
            }
        } else {
            UserDefaults.standard.set(false, forKey: "notifications")
        }
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
}
