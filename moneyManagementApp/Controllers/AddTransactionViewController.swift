//
//  AddTransactionViewController.swift
//  moneyManagementApp
//
//  Created by Ayşe Hotaman on 4.07.2022.
//

import UIKit
import CoreData

class AddTransactionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var attachLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    var moneySpend: String = ""
    var tid = UUID().uuidString.lowercased()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // these views are invisible at the start
        datePicker.isHidden = true
        imageView.isHidden = true
        
        // select date from date picker
        pickDate()
        
        // add photos from library
        attachLabel.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        attachLabel.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    func pickDate() {
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        dateTextField.addGestureRecognizer(tapGesture)

    }
    
    @objc func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
        datePicker.endEditing(true)
        datePicker.isHidden = true // hide date picker after select date
    }
    
    // do not show date picker before select other values
    @objc func showDatePicker() {
        datePicker.isHidden = false
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imageView.isHidden = false
        self.imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveTransactionInfo() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newTransaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: context)
        
        // attributes
        newTransaction.setValue(dateTextField.text!, forKey: "date")
        newTransaction.setValue(categoryTextField.text!, forKey: "category")
        newTransaction.setValue(noteTextField.text!, forKey: "note")
        
        // convert to float
        if let amount = Float(amountTextField.text!) {
            newTransaction.setValue(amount, forKey: "amount")
        }
        
        if segmentControl.selectedSegmentIndex == 0 {
            newTransaction.setValue("gider", forKey: "expanse")
        } else {
            newTransaction.setValue("gelir", forKey: "expanse")
        }
        
        newTransaction.setValue(tid, forKey: "transactionid")
        
        // adds receipt image
        let image = imageView.image!.jpegData(compressionQuality: 0.5)
        newTransaction.setValue(image, forKey: "image")
        
        // checks whether the save was successful
        do {
            try context.save()
            print("İşlem bilgileri başarılı bir şekilde kaydedildi!")
            
        } catch {
            print("İşlem bilgileri kaydedilirken bir hata oluştu!")
        }
    }
    
    // save transaction info and segue to home or show message to perform segue or add new transactions
    @IBAction func addTransaction(_ sender: Any) {

        saveTransactionInfo()
        
        performSegue(withIdentifier: "toAddHomeVC", sender: nil)
    }
    
    @IBAction func segmentedSwitcher(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            moneySpend = "gider" // expense
        } else {
            moneySpend = "gelir" // income
        }
    }
}
