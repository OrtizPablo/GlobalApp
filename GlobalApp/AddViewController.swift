//
//  AddViewController.swift
//  GlobalApp
//
//  Created by Pablo Ortiz Rodríguez on 26/11/17.
//  Copyright © 2017 Pablo Ortiz Rodríguez. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    // MARK: Properties
    var name = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    // Function that updates the quantity of the piece of clothing that the system has
    func updateQuantityProvider() {
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
                    let newQuantity = clothing.value(forKey: "quantity") as! Int + Int(numberText.text!)!
                    clothing.setValue(newQuantity, forKey: "quantity")
                    try managedContext.save()
                }
            }
        } catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Function that check if the number label contains an Int that is higher than zero
    func checkNumber() -> Bool {
        // If the number label contains an Int
        if Int(numberText.text!) != nil
        {
            let number = Int(numberText.text!) ?? 0
            // If the number is greater than zero
            if number > 0
            {
                return true
            }
            // Number less than zero error
            else
            {
                let alertView = UIAlertController(title: "Error", message: "You must insert a number greater than zero", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
                return false
            }
        }
        // Number insertion error
        else
        {
            let alertView = UIAlertController(title: "Error", message: "You must insert a number", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return false
        }
    }
    
    // Button which will update the quantity of clothes
    @IBAction func AddClothes(_ sender: UIButton) {
        if checkNumber()
        {
            updateQuantityProvider()
            self.performSegue(withIdentifier: "unwindToMenu1", sender: self)
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
