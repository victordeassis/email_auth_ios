//
//  ViewController.swift
//  CustomEmailLogin
//
//  Created by Victor de Assis on 24/03/18.
//  Copyright © 2018 Victor de Assis. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBOutlet weak var signinSelector: UISegmentedControl!
    
    @IBOutlet weak var signinLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        // Flip the boolean
        isSignIn = !isSignIn
        
        // Check the bool and set the button and labels
        if isSignIn {
            signinLabel.text = "Sign In"
            signinButton.setTitle("Sign In", for: .normal)
        }
        else {
            signinLabel.text = "Register"
            signinButton.setTitle("Register", for: .normal)
        }
        
    }
    
    @IBAction func signinButtonTapped(_ sender: UIButton) {
        
        // TODO: Do some form validation on the email and password
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
        
            // Check if it's sign in or register
            if isSignIn {
                // Sign in the user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    
                    // Check that user isn't nil
                    if let u = user {
                        // User is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        // Error: check error and show message
                        if error != nil {
                            self.errorLabel.isHidden = false
                            
                            self.errorLabel.text = error?.localizedDescription
                            
                            
                        }
                        print(error)
                    }
                }
            }
            else {
                // Register the user with Firebase
                
                Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                    
                    // Check that user isn't nil
                    if let u = user {
                        // User is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        // Error: check error and show message
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}

