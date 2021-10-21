//
//  SignUpViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Changes the color and shape of the login and signup buttons
        signUpButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.tintColor = UIColor.white
        logInButton.tintColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        
        //Log out every time we start the app
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
        }
        
        //Moves to the tab bar controller if we sucessfully sign up
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
              self.emailField.text = nil
              self.passwordField.text = nil
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
        }
    }
    
    @IBAction func pressedSignUp(_ sender: Any) {
        //checks if the email and password texts are filled
        guard let email = emailField.text,
              let password = passwordField.text,
              email.count > 0,
              password.count > 0
        else {
            return
        }
        
        //try to create a new user
        Auth.auth().createUser(withEmail: email, password: password) {
            user, error in
            if error == nil {
                //Creation sucessful, logging in after account creation
                Auth.auth().signIn(withEmail: email, password: password)
            }
            else {
                //There is an error
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
}
