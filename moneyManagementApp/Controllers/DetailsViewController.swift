//
//  DetailsViewController.swift
//  moneyManagementApp
//
//  Created by Ayşe Hotaman on 5.07.2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var opType: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var receiptImage: UIImageView!
    
    var chosenTransactionId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromCore()
    }

    func getDataFromCore() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.returnsObjectsAsFaults = false // helps to fetch objects faster
        
        // helps to filter datas according to transactionid
        let predicate = NSPredicate(format: "transactionid = %@", chosenTransactionId)
        fetchRequest.predicate = predicate
        
        do {
            let results =  try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    amountLabel.text! = String(result.value(forKey: "amount") as! Float)
                    categoryLabel.text! = result.value(forKey: "category") as! String
                    dateLabel.text! = result.value(forKey: "date") as! String
                    noteLabel.text! = result.value(forKey: "note") as! String
                    opType.text! = result.value(forKey: "expanse") as! String
                    
                    if let imageData = result.value(forKey:"image") as? Data {
                        let image = UIImage(data: imageData)
                        receiptImage.image = image
                    }
                }
            }
        } catch {
            print("error!")
        }
    }
}

