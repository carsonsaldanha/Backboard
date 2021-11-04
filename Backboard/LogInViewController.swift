//
//  ViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var teamPickerView: UIPickerView!
    
    var teams: [String] = ["None", "76ers", "Bucks", "Bulls", "Cavaliers", "Celtics", "Clippers",
                           "Grizzlies", "Hawks", "Heat", "Hornets", "Jazz", "Kings",
                           "Knicks", "Lakers", "Magic", "Mavericks", "Nets", "Nuggets",
                           "Pacers", "Pelicans", "Pistons", "Raptors", "Rockets", "Spurs",
                           "Suns", "Thunder", "Timberwolves", "Trail Blazers", "Warriors", "Wizards"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and data source of the picker to self
        teamPickerView.delegate = self
        teamPickerView.dataSource = self
        
        // Used to hide the software keyboard
        emailField.delegate = self
        passwordField.delegate = self
        
        // Changes the color and shape of the login and signup buttons
        logInButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        logInButton.layer.cornerRadius = 25.0
        logInButton.tintColor = UIColor.white
        backButton.tintColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        
        // Moves to the tab bar controller if we sucessfully sign in
        Auth.auth().addStateDidChangeListener { auth, user in
            if (user != nil) {
                self.emailField.text = nil
                self.passwordField.text = nil
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
        }
    }
    
    // Number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows of data for picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    // Returns the team for the row and component (column) on the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teams[row]
    }
    
    // Uses Firebase authentication to log in a user upon button press
    @IBAction func pressedLogIn(_ sender: Any) {
        // Checks if the email and password texts are filled
        guard let email = emailField.text,
              let password = passwordField.text,
              email.count > 0,
              password.count > 0
        else {
            return
        }
        
        // Trying to log in
        Auth.auth().signIn(withEmail: email, password: password) {
            user, error in
            if let error = error, user == nil {
                // There is an error with our login credentials
                let alert = UIAlertController(title: "Sign in failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Define a key and value for the user's favorite team
        let kFavoriteTeamKey = "favoriteTeam"
        let team = teams[teamPickerView.selectedRow(inComponent: 0)]
        // Get a reference to the global user defaults object and store the user's favorite team
        let defaults = UserDefaults.standard
        defaults.set(team, forKey: kFavoriteTeamKey)
    }
    
    // Go back to the signup page if the "Back" button is pressed
    @IBAction func pressedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Hides the software keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Hides the software keyboard when tapping on the background
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
