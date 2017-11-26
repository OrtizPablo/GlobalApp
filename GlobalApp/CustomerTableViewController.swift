//
//  CustomerTableViewController.swift
//  GlobalApp
//
//  Created by Pablo Ortiz Rodríguez on 24/11/17.
//  Copyright © 2017 Pablo Ortiz Rodríguez. All rights reserved.
//

import UIKit
import CoreData

class CustomerTableViewController: UITableViewController {
    
    //MARK: Properties
    var clothes: [NSManagedObject] = []
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAvailableClothes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAvailableClothes()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clothes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath)
        //Getting the String from the clothes Array
        cell.textLabel?.text = clothes[indexPath.row].value(forKey: "name") as? String
 
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue used to buy the piece of clothing
        if segue.destination.isKind(of: PaymentViewController.self)
        {
            let destination = segue.destination as! PaymentViewController
            destination.name = clothes[tableView.indexPathForSelectedRow![1]].value(forKey: "name") as! String
            destination.gender = clothes[tableView.indexPathForSelectedRow![1]].value(forKey: "gender") as! String
            destination.price = clothes[tableView.indexPathForSelectedRow![1]].value(forKey: "price") as! Double
        }
    }
    
    // Function that fetches the data of the clothes that has a positive quantity value
    func fetchAvailableClothes() {
        
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
            
            var index = 0
            
            // Deleting the data from the array clothes with a zero value in its quantity
            while index < clothes.count
            {
                let quantity = clothes[index].value(forKey: "quantity") as! Int
                if  quantity < 1
                {
                    clothes.remove(at: index)
                    index -= 1
                }
                index += 1
            }
        } catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Function that fetches the data of the clothes that has a positive quantity value and the gender selected
    func fetchClothesByGender(genderPar: String) {
        
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
            
            var index = 0
            
            // Deleting data from the array clothes with a zero value in its quantity
            // And deleting data from the array if its gender is not equal as the gender passed by parameter
            while index < clothes.count
            {
                let quantity = clothes[index].value(forKey: "quantity") as! Int
                let gender = clothes[index].value(forKey: "gender") as! String
                if  quantity < 1 || gender != genderPar
                {
                    clothes.remove(at: index)
                    index -= 1
                }
                index += 1
            }
        } catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Segue to go backwards from the PaymentViewController to CustomerTableViewController
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    // Action made when the segmentedControl is pressed
    @IBAction func filterClothes(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        // If All is selected -> show all the clothes
        case 0:
            fetchAvailableClothes()
        // If Woman is selected -> show all the clothes for women
        case 1:
            fetchClothesByGender(genderPar: "Woman")
        // If Man is selected -> show all the clothes for men
        default:
            fetchClothesByGender(genderPar: "Man")
        }
        // Updating data in the table view
        self.tableView.reloadData()
    }
    

}

