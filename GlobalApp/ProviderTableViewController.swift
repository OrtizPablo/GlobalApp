//
//  ProviderTableViewController.swift
//  GlobalApp
//
//  Created by Pablo Ortiz Rodríguez on 26/11/17.
//  Copyright © 2017 Pablo Ortiz Rodríguez. All rights reserved.
//

import UIKit
import CoreData

class ProviderTableViewController: UITableViewController {
    
    //MARK: Properties
    var clothes: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllClothes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAllClothes()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "providerCell", for: indexPath)
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
        if segue.destination.isKind(of: AddViewController.self)
        {
            let destination = segue.destination as! AddViewController
            destination.name = clothes[tableView.indexPathForSelectedRow![1]].value(forKey: "name") as! String
        }
    }
    
    // Function that fetches all the Clothes data
    func fetchAllClothes() {
        
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
        } catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Segue to go backwards from AddViewController to ProviderTableViewController
    @IBAction func unwindToMenu1(segue: UIStoryboardSegue) {}
    
    
    // Segue to go backwards from AddProductViewController to ProviderTableViewController
    @IBAction func unwindToMenu2(segue: UIStoryboardSegue) {}
    
}
