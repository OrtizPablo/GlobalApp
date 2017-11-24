//
//  ViewController.swift
//  GlobalApp
//
//  Created by Pablo Ortiz Rodríguez on 24/11/17.
//  Copyright © 2017 Pablo Ortiz Rodríguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Actions
    
    @IBAction func Enter(_ sender: UIButton) {
        // If the user is a customer
        if user.text == "Customer" && password.text == "Cust1234"
        {
            performSegue(withIdentifier: "CustomerSegue", sender: self)
        }
            //If the user is a provider
        else if user.text == "Provider" && password.text == "Prov1234"
        {
            performSegue(withIdentifier: "ProviderSegue", sender: self)
        }
            //Error message
        else
        {
            let alertView = UIAlertController(title: "Error", message: "Unknown contact", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
}

