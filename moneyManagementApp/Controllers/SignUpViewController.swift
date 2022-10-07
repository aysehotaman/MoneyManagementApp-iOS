//
//  ViewController.swift
//  moneyManagementApp
//
//  Created by Ayşe Hotaman on 2.07.2022.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var email: String = ""
    var password: String = ""
    let uuid = UUID().uuidString.lowercased()
    
    let datePicker = UIDatePicker()
    var doneButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        userImage.addGestureRecognizer(imageTapRecognizer)
        
        createDatePicker()
        
        signUpButton.isEnabled = false
        
        usernameTextField.addTarget(self, action: #selector(checkButtonEnable), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(checkButtonEnable), for: .editingChanged)
        birthdayTextField.addTarget(self, action: #selector(checkButtonEnable), for: .editingChanged)
    }
    
    // user must enter username, id and birth date for user info.
    @objc func checkButtonEnable() {
        if usernameTextField.text!.isEmpty || idTextField.text!.isEmpty || birthdayTextField.text!.isEmpty {
            signUpButton.isEnabled = false
        } else {
            signUpButton.isEnabled = true
        }
    }
    
    //selecting image
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func createDatePicker() {
        // toolbar
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        // bar button
        let done: UIBarButtonItem = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(doneClicked))
        
        doneToolbar.setItems([done], animated: true)
        
        // assign toolbar
        birthdayTextField.inputAccessoryView = doneToolbar
        
        // assign date picker to the text field
        birthdayTextField.inputView = datePicker
        birthdayTextField.textAlignment = .center
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func doneClicked() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        birthdayTextField.text = selectedDate
        self.view.endEditing(true)
    }
    
    func saveUserInfo() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        // attributes
        newUser.setValue(usernameTextField.text!, forKey: "username")
        newUser.setValue(birthdayTextField.text!, forKey: "birthday")
        
        // convert to integer
        if let id = Int(idTextField.text!) {
            newUser.setValue(id, forKey: "tcid")
        }
        
        // convert to integer
        if let phone = Int(phoneNoTextField.text!) {
            newUser.setValue(phone, forKey: "phone")
        }
        
        newUser.setValue(email, forKey: "email")
        newUser.setValue(password, forKey: "password")
        newUser.setValue(uuid, forKey: "userid")
        // to save user photo.
        let image = userImage.image!.jpegData(compressionQuality: 0.5)
        newUser.setValue(image, forKey: "userimage")
        
        do {
            try context.save()
            print("Kullanıcı bilgileri başarılı bir şekilde kaydedildi!")
            
        } catch {
            print("Kullanıcı bilgileri kaydedilirken bir hata oluştu!")
        }
    }
    
    func createEmail() -> String {
        
        let randomInt = Int.random(in: 0..<100)
        // add random numbers to the end of given username
        return "\(usernameTextField.text!)\(randomInt)@gmail.com"
    }
    
    func createPassword() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    // email ve password are transferred to other vc.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfoVC" {
            
            let destinationVC = segue.destination as! InfoViewController
            
            email = createEmail()
            password = createPassword()
            
            saveUserInfo() // if this not included email and password will be empty
            
            destinationVC.userEmail = email
            destinationVC.userPassword = password
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        // perform segue to info vc.
        performSegue(withIdentifier: "toInfoVC", sender: nil)
    }
}

