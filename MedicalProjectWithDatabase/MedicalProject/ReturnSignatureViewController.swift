//
//  ReturnSignatureViewController.swift
//  MedicalProject
//
//

import UIKit
import Firebase
import FirebaseStorage
import EPSignature

class ReturnSignatureViewController: UIViewController, EPSignatureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var custName:String?
    var custEquipment: [String: Any] = [:]
    var custEquipString = ""
    let returnAgreement = "\n\n\t\tRETURN TERMS AND CONDITIONS\n\n" +
        "1. The RENTER guarantees that all equipment listed above is being returned in the same condition it was received, and has not been damaged or modified in any way.\n\n" +
        "2. If any equipment is found to be damaged, the RENTER agrees to pay for any damages or the cost of replacing said equipment in full.\n\n" +
        "By my signature I acknowledge that I have received a copy of this agreement and all above listed items. I have read or heard this contract read aloud, and understand the conditions of the agreement. My signature is my commitment to adhere to these responsibilities and terms."
    
    @IBOutlet weak var agreementTextView: UITextView!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgViewSignature: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key, value) in custEquipment {
            custEquipString += ("\n\t\(key): \(value)")
        }
        
        user.text = custName
        let personalString = "I (listed above or representative of the above listed), hereby agree to the terms below for the following equipment:\n\(custEquipString)"
        agreementTextView.text = personalString + returnAgreement
    }
    
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
        
        let storageRef = Storage.storage().reference().child(user.text! + " -ReturnEquipment".trimmingCharacters(in: .whitespaces))
        
        
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



