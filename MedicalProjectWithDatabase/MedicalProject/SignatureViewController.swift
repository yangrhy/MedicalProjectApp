//
//  SignatureViewController.swift
//  MedicalProject
//
//

import UIKit
import Firebase
import FirebaseStorage
import EPSignature

class SignatureViewController: UIViewController, EPSignatureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgViewSignature: UIImageView!
    
    @IBAction func onTouchSignatureButton(sender: AnyObject) {
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
        signatureVC.subtitleText = "I agree to the terms and conditions"
        //signatureVC.title = "John Doe"
        let nav = UINavigationController(rootViewController: signatureVC)
        present(nav, animated: true, completion: nil)
    }
    
    func epSignature(_: EPSignatureViewController, didCancel error : NSError) {
        print("User canceled")
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        imgViewSignature.image = signatureImage
        imgWidthConstraint.constant = boundingRect.size.width
        imgHeightConstraint.constant = boundingRect.size.height
    }
    
    
    @IBOutlet weak var user: UITextField!
    
    
    @IBAction func uploadSignature(_ sender: Any) {
        
        let storageRef = Storage.storage().reference().child(user.text!.trimmingCharacters(in: .whitespaces))
        
        
        if let uploadData = UIImagePNGRepresentation(self.imgViewSignature.image!){
            storageRef.putData(uploadData, metadata: nil, completion:
                {
                    (metadata, error) in
                    if error != nil {
                        print("error")
                        return
                    }
            }
            )
        }
        
        let alert = UIAlertController(title: "Signature Submitted", message: "Information has been updated.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        user.text = ""
        imgViewSignature.image = nil
        
    }
    
    

    
}


