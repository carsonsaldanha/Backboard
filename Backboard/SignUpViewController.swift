//
//  SignUpViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
