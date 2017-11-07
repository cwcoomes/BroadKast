//
//  registerViewController.swift
//  BroadKastUI
//
//  Created by Ubicomp4 on 10/19/17.
//  Copyright © 2017 Ubicomp4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


//struct that we store in the database
struct UserInformation{
    var username: String
    var uid: String
    let ref: DatabaseReference?
    init( us: String, ui: String){
        self.username = us
        self.uid = ui
       
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        uid = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        username = snapshotValue["username"] as! String
        uid = snapshotValue["uid"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "username": username,
            "uid": uid,
            
        ]
    }
}



class registerViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    //userref will be used to store user in database
    let userRef = Database.database().reference(withPath: "Users")
    
    
    @IBAction func requirements(_ sender: Any) {
        let alert = UIAlertController(title: "Requirements: " , message: "Email must be valid and working. Password must have ten characters with at least one uppercase, one number, and one symbol.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        if(validateEmail(email: emailField) && validatePassword(password: passwordField)){
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error != nil {
                    
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .emailAlreadyInUse:
                            let alert = UIAlertController(title: "Error: " , message: "Account already exists.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        default:
                            let alert = UIAlertController(title: "Error: " , message: "Contact admin, something went wrong.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    //Creating the user in our database so we have a connection to the username
                    let userID = Auth.auth().currentUser!.uid
                    let userItemRef = self.userRef.child(userID)
                    let userItem = UserInformation(us: self.usernameField.text!, ui: userID )
                    userItemRef.setValue(userItem.toAnyObject())
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
           
            
            
        } else {
            
            let alert = UIAlertController(title: "Requirements: " , message: "Email must be valid and working. Password must have ten characters with at least one uppercase, one number, and one symbol.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateEmail(email: UITextField) -> Bool {
        
        //determines if user input contains whitespaces before or after email and trims them from email
        guard let trimEmail = email.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }
        
        //check if the email conforms to nsdatadetector email link type
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        //if email was trimmed, new character range is created range i
        let range = NSMakeRange(0, NSString(string: trimEmail).length)
        
        let matchAll = dataDetector.matches(in: trimEmail, options: [], range: range)
        
        //condition checks if email meets previous conditions and returns true
        if ((matchAll.count == 1) && (matchAll.first?.url?.absoluteString.contains("mailto:") == true))
        {
            email.text! = trimEmail
            return true
        }
        return false
    }
    
    func validatePassword(password: UITextField) -> Bool {
        
        //use nspredicate and regex for password requirements to see if user input matches
        let pwTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{10,64}$")
        
        return pwTest.evaluate(with: password.text!)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// Ensures that pressing "Return" closes keyboard
extension registerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
