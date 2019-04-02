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
    var custName:String?
    var custEquipment: [String: Any] = [:]
    var custEquipString = ""
    let purchaseAgreement = "\n\n\t\tPURCHASE TERMS AND CONDITIONS\n\n" +
        "1. The Seller guarantees that he/she is the true and lawful owner of the above described Goods and that it is free of all encumbrances, liens and any and all legal claims.\n\n" +
        "2. The Seller warrants that no person shall have legal claim against the Buyer for the removal of the Goods hereby sold and the Seller warrants to indemnify and hold harmless the Buyer from any and all adverse claims arising from the sale of the Goods.\n\n" +
        "3. The Seller or his/her agent gives no warranty or guarantee other than those specified in 1. and 2. above.\n\n" +
        "4. The Buyer admits having inspected the Goods to his/her satisfaction and that no guarantees or warranties were expressed or implied by the Seller or his/her agent regarding the condition, quality or fitness for any purpose of the Goods.\n\n" +
        "5. The Goods are sold As-Is and the Seller shall not be liable for any defects, patent, latent or otherwise.\n\n" +
        "6. The risk passes to the Buyer once the Buyer or his/her agent takes possession of the Goods.\n\n" +
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
        agreementTextView.text = personalString + purchaseAgreement
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


