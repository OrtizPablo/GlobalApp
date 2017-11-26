//
//  AddClothesViewController.swift
//  GlobalApp
//
//  Created by Pablo Ortiz Rodríguez on 26/11/17.
//  Copyright © 2017 Pablo Ortiz Rodríguez. All rights reserved.
//

import UIKit
import CoreData

class AddClothesViewController: UIViewController {
    
    // MARK: Properties
    
    var clothes: [NSManagedObject] = []
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var quantityText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    // Button to insert a piece of clothing
    @IBAction func AddButton(_ sender: UIButton) {
        
        if check() && checkInsert()
        {
            let name = nameText.text ?? ""
            let gender = genderText.text ?? ""
            let price = Double(priceText.text!) ?? 0.0
            let quantity = Int(quantityText.text!) ?? 0
        
            saveClothes(name: name, gender: gender, price: price, quantity: quantity)
            self.performSegue(withIdentifier: "unwindToMenu2", sender: self)
        }
    }
    
    // Function that saves the clothes persistently
    func saveClothes(name: String, gender: String, price: Double, quantity: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        // Getting the NSManagedObjectContext
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Creating managed object and inserting it into the managed object context
        let entity = NSEntityDescription.entity(forEntityName: "Clothes", in: managedContext)!
        let clothesInsert = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Linking the parameters to the entity columns to insert the data
        clothesInsert.setValue(name, forKeyPath: "name")
        clothesInsert.setValue(gender, forKeyPath: "gender")
        clothesInsert.setValue(price, forKeyPath: "price")
        clothesInsert.setValue(quantity, forKeyPath: "quantity")
        
        // Commiting the data
        do
        {
            try managedContext.save()
            clothes.append(clothesInsert)
        } catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Function that checks if the piece of clothing can be saved
    func check() -> Bool {
        // Empty field error
        if nameText.text == "" || genderText.text == "" || priceText.text == "" || quantityText.text == ""
        {
            let alertView = UIAlertController(title: "Error", message: "One or more of the text fields are empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        else
        {
            let gender = genderText.text ?? ""
            let price = Double(priceText.text!) ?? 0.0
            let quantity = Int(quantityText.text!) ?? 0
            // Incorrect price error
            if price < 0.01
            {
                let alertView = UIAlertController(title: "Error", message: "Insert a correct price greater than 0", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
                return false
            }
            // Incorrect quantity error
            else if quantity < 1
            {
                let alertView = UIAlertController(title: "Error", message: "Insert a correct quantity greater than 0", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
                return false
            }
            else if gender == "Man" || gender == "Woman"{
                return true
            }
            // Incorrect gender error
            else
            {
                let alertView = UIAlertController(title: "Error", message: "Insert a correct gender: Man or Woman", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
                return false
            }
        }
    }
    
    func checkInsert() -> Bool {
        
        var varCheck = true
        
        // Getting the NSManagedObjectContext
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return false
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
                if clothing.value(forKey: "name") as? String == nameText.text
                {
                    varCheck = false
                }
            }
        } catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        if !varCheck
        {
            let alertView = UIAlertController(title: "Error", message: "The piece of clothing inserted is already in the system", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
        return varCheck
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
