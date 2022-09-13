//
//  ProfileViewController.swift
//  moneyManagementApp
//
//  Created by Ayşe Hotaman on 4.07.2022.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    
    var pid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(pid)
        
        // customize our profile image
        profileImage.roundedImage(borderColor: UIColor.black.cgColor, cornerRadius: 60)
        self.profileImage.layer.masksToBounds = true
        
        getUserData()
    }
    
    func getUserData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false //daha hızlı oluyor
        
        // fetch info. according to userid
        let predicate = NSPredicate(format: "userid = %@", pid)
        fetchRequest.predicate = predicate
        
        do {
            let results =  try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    usernameLabel.text! = result.value(forKey: "username") as! String
                    birthdayLabel.text! = result.value(forKey: "birthday") as! String
                    idLabel.text! = String(result.value(forKey: "tcid") as! Int)
                    phoneNoLabel.text! = String(result.value(forKey: "phone") as! Int)
                    
                    if let imageData = result.value(forKey: "userimage") as? Data {
                        let image = UIImage(data: imageData)
                        profileImage.image = image
                    }
                }
            }
        } catch {
            print("error!")
        }
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "afterLogout", sender: nil)
        
    }
}

extension UIImageView {
    // round's a UIImageView with borderColor and corner radius
    func roundedImage(borderColor: CGColor, cornerRadius: CGFloat) {
        contentMode = .scaleAspectFill
        sizeToFit()
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1.0
        clipsToBounds = true
        layer.masksToBounds = true
        layer.borderColor = borderColor
    }
}
