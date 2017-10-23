//
//  ViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 10/19/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwipeCellKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func toLogin(_ sender: Any) {
        performSegue(withIdentifier: "login2register", sender: self)
    }
    @IBAction func toLanding(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            // ...
            
            
        }
        
        performSegue(withIdentifier: "login2landing", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

