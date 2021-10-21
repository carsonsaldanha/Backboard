//
//  ViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
