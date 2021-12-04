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
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var systemButton: DLRadioButton!
    @IBOutlet weak var lightButton: DLRadioButton!
    @IBOutlet weak var darkButton: DLRadioButton!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var favoriteTeamPicker: UITextField!
    
    var currentView: UIUserInterfaceStyle!
    var updateView: UIUserInterfaceStyle!
    var pressedSave = false
    var teamPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamPicker.delegate = self
        teamPicker.dataSource = self
        
        UNUserNotificationCenter.current().delegate = self
        
        // Get and display the favorite team and account email
        emailLabel.text! = (Auth.auth().currentUser?.email)!
        
        let defaults = UserDefaults.standard
        let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
        
        // Format team picker and display current favorite team
        favoriteTeamPicker.inputView = teamPicker
        favoriteTeamPicker.tintColor = .clear
        favoriteTeamPicker.text? = retrievedFavoriteTeam ?? "None"
        favoriteTeamPicker.layer.cornerRadius = 10.0
        favoriteTeamPicker.layer.borderWidth = 1.5
        favoriteTeamPicker.textColor = UIColor.white
        
        // Format sign out button
        signOutButton.layer.cornerRadius = 25.0
        signOutButton.tintColor = UIColor.white
        
        // Sets colors based on team theme
        setButtonColors()
        
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
    
    // Adds the lines between the setting rows
    override func viewDidAppear(_ animated: Bool) {
        let screenWidth = UIScreen.main.bounds.width
        
        let lineView = UIView(frame: CGRect(x: 20, y: emailLabel.center.y + 25, width: screenWidth - 40, height: 1))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
        
        let lineView2 = UIView(frame: CGRect(x: 20, y: favoriteTeamPicker.center.y + 25, width: screenWidth - 40, height: 1))
        lineView2.layer.borderWidth = 1.0
        lineView2.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView2)
        
        let lineView3 = UIView(frame: CGRect(x: 20, y: themeLabel.center.y + 25, width: screenWidth - 40, height: 1))
        lineView3.layer.borderWidth = 1.0
        lineView3.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView3)
        
        let lineView4 = UIView(frame: CGRect(x: 87, y: systemButton.center.y + 25, width: screenWidth - 107, height: 1))
        lineView4.layer.borderWidth = 1.0
        lineView4.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView4)
        
        let lineView5 = UIView(frame: CGRect(x: 87, y: lightButton.center.y + 25, width: screenWidth - 107, height: 1))
        lineView5.layer.borderWidth = 1.0
        lineView5.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView5)
        
        let lineView6 = UIView(frame: CGRect(x: 87, y: darkButton.center.y + 25, width: screenWidth - 107, height: 1))
        lineView6.layer.borderWidth = 1.0
        lineView6.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView6)
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
    
    // Log out if we press the sign out button
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
    
    // Helper method to set button colors based on favorite team theme
    func setButtonColors() {
        let defaults = UserDefaults.standard
        let retrievedFavoriteTeam = defaults.string(forKey: "favoriteTeam")
        
        // Retrieves team primary and secondary colors
        let hexCode = teamHexCodes[retrievedFavoriteTeam ?? "None"]
        let primaryHex = hexCode!.0
        let secondaryHex = hexCode!.1
        let primaryColor = UIColor.init(red: CGFloat(Double(primaryHex.0)/255), green: CGFloat(Double(primaryHex.1)/255), blue: CGFloat(Double(primaryHex.2)/255), alpha: 1)
        let secondaryColor = UIColor.init(red: CGFloat(Double(secondaryHex.0)/255), green: CGFloat(Double(secondaryHex.1)/255), blue: CGFloat(Double(secondaryHex.2)/255), alpha: 1)
        
        // Design for the signout button
        signOutButton.backgroundColor = secondaryColor
        
        // Change accent color of the radio buttons and notifications switch with the team color
        DLRadioButton.appearance().tintColor = primaryColor
        notificationsSwitch.onTintColor = primaryColor

        // Change accent color of favorite team picker based on selection
        favoriteTeamPicker.layer.borderColor = secondaryColor.cgColor
        favoriteTeamPicker.layer.backgroundColor = secondaryColor.cgColor
    }
}

// A class extension that allows users to change their favorite team via a text field acting as picker
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leagueTeams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leagueTeams[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Changes user defaults based on new team selection
        let defaults = UserDefaults.standard
        defaults.set(leagueTeams[row], forKey: "favoriteTeam")
        
        // Updates app theme based on team selection
        formatTeamColors()
        setButtonColors()
        favoriteTeamPicker.text = leagueTeams[row]
        
        // Removes and re-adds UIWindow subviews to view hierarchy to update tab bar
        let windowList = UIApplication.shared.windows
        let uiWindow = windowList[0]
        for view in uiWindow.subviews {
            view.removeFromSuperview()
            uiWindow.addSubview(view)
        }
        
        // Closes out of picker upon selection
        favoriteTeamPicker.resignFirstResponder()
    }
}
