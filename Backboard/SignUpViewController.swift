//
//  SignUpViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signUpButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.tintColor = UIColor.white
        logInButton.tintColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
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
