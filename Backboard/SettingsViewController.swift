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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.backgroundColor = UIColor.init(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
        saveButton.layer.cornerRadius = 25.0
        saveButton.tintColor = UIColor.white
        
        signOutButton.backgroundColor = UIColor.init(red: 231/255, green: 51/255, blue: 55/255, alpha: 1)
        signOutButton.layer.cornerRadius = 25.0
        signOutButton.tintColor = UIColor.white
        
        emailLabel.text! = (Auth.auth().currentUser?.email)!
        
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
    }
    
    @IBAction func pressedSystemButton(_ sender: Any) {
        var osTheme: UIUserInterfaceStyle {
            return UIScreen.main.traitCollection.userInterfaceStyle
        }
        
        overrideUserInterfaceStyle = osTheme
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = osTheme
        }
    }
    
    @IBAction func pressedLightButton(_ sender: Any) {
        overrideUserInterfaceStyle = .light
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func pressedDarkButton(_ sender: Any) {
        overrideUserInterfaceStyle = .dark
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    @IBAction func pressedAllTeams(_ sender: Any) {
        
    }
    
    @IBAction func pressedFavoriteTeam(_ sender: Any) {
        
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
