//
//  SignUpViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
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
        signUpButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.tintColor = UIColor.white
        logInButton.tintColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        
        // Moves to the tab bar controller if we sucessfully sign up
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

    // Uses Firebase authentication to sign up a user upon button press
    @IBAction func pressedSignUp(_ sender: Any) {
        // Checks if the email and password texts are filled
        guard let email = emailField.text,
              let password = passwordField.text,
              email.count > 0,
              password.count > 0
        else {
            return
        }
        
        // Try to create a new user
        Auth.auth().createUser(withEmail: email, password: password) {
            user, error in
            if error == nil {
                // Creation sucessful, logging in after account creation
                Auth.auth().signIn(withEmail: email, password: password)
            }
            else {
                // There is an error
                let alert = UIAlertController(title: "Sign in failed", message: error?.localizedDescription, preferredStyle: .alert)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        emailField.text = nil
        passwordField.text = nil
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
