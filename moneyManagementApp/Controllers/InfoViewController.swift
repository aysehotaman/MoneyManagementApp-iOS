//
//  InfoViewController.swift
//  moneyManagementApp
//
//  Created by Ayşe Hotaman on 3.07.2022.
//

import UIKit
import CoreData

class InfoViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
     // this is equal to the email and password in the previous page
    var userEmail: String = ""
    var userPassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text! = userEmail
        passwordLabel.text! = userPassword
        
    }
    // perform segue to home
    @IBAction func okButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toLoginVC", sender: nil)
    }
    
}
