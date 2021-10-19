//
//  ViewController.swift
//  Backboard
//
//  Created by Saldanha, Carson C on 10/12/21.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logInButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        logInButton.layer.cornerRadius = 25.0
        logInButton.tintColor = UIColor.white
        backButton.tintColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
    }
    
}

