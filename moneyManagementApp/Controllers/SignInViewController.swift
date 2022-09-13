//
//  SignInViewController.swift
//  moneyManagementApp
//
//  Created by Ayşe Hotaman on 3.07.2022.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var unid: String = ""
    let TransIndexViewController = 1
    let ProfileIndexViewController = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation operations are done in vc that will return
        let backBarButtonItem = UIBarButtonItem(title: "Geri", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if checkInfo() {
            // perform segue
            self.performSegue(withIdentifier: "toTabBar", sender: nil)
        
        } else {
            // show alert message
            makeAlert(titleInput: "Bir hata oluştu!", messageInput: "Lütfen hesap bilgilerinizi tekrar giriniz.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // go to tab bar
        if segue.identifier == "toTabBar" {
            let tabBarVC = segue.destination as! UITabBarController
  
            let profileVC = tabBarVC.viewControllers![ProfileIndexViewController] as! ProfileViewController
            
            profileVC.pid = unid
            //tabBarVC.selectedIndex = 1 // if this uncomment it goes to the add trans. vc. at boot
        }
    }
    
    // perform segue to sign up vc.
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    // check if email and passwords are compatible for each other
    func checkInfo() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false //daha hızlı oluyor
        
        // check compactility of password and email
        let predicate = NSPredicate(format: "email == %@ AND password == %@", self.emailTextField.text!, self.passwordTextField.text!)
        fetchRequest.predicate = predicate
        
        do {
            let results =  try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    // define id for user
                    unid = result.value(forKey: "userid") as! String
                }
                
                return true
                
            } else {
                // no data saved
                return false
            }
        } catch {
            print("error!")
        }
        
        return false
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Tamam", style: .default) { (UIAlertAction) in print("Button clicked")}
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
