//
//  PaymentViewController.swift
//  GlobalApp
//
//  Created by Pablo Ortiz Rodríguez on 24/11/17.
//  Copyright © 2017 Pablo Ortiz Rodríguez. All rights reserved.
//

import UIKit
import CoreData

class PaymentViewController: UIViewController {
    
    //MARK: Properties
    
    var name: String = ""
    var gender: String = ""
    var price: Double = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        genderLabel.text = gender
        priceLabel.text = price.description + " Pounds" 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Pay(_ sender: UIButton) {
        updateQuantityCustomer()
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    // Function that updates the quantity of the piece of clothing that the system has
    func updateQuantityCustomer() {
        var clothes:[NSManagedObject] = []
        // Getting the NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Creating the object to fetch the data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Clothes")
        
        // Fetching the data from the entity
        do
        {
            clothes = try managedContext.fetch(fetchRequest)
            for clothing in clothes
            {
                if clothing.value(forKey: "name") as! String == name
                {
                    // Updating and saving the data
                    let newQuantity = clothing.value(forKey: "quantity") as! Int - 1
                    clothing.setValue(newQuantity, forKey: "quantity")
                    try managedContext.save()
                }
            }
        } catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
