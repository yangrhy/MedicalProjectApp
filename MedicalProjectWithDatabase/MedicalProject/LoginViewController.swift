//
//  LoginViewController.swift
//  MedicalProject
//
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {


//Outlets
@IBOutlet weak var emailTextField: UITextField!
@IBOutlet weak var passwordTextField: UITextField!


    //Login Action
    @IBAction func loginAction(_ sender: AnyObject) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    print("You have successfully logged in")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NaviView")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    

                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    
    
    }
}
