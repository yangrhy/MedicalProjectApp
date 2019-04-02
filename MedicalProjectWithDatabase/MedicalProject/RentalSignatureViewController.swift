//
//  RentalSignatureViewController.swift
//  MedicalProject
//
//

import UIKit
import Firebase
import FirebaseStorage
import EPSignature

class RentalSignatureViewController: UIViewController, EPSignatureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var custName:String?
    var custEquipment: [String: Any] = [:]
    var custEquipString = ""

    @IBOutlet weak var agreementTextView: UITextView!
    
    let rentalAgreement = "\n\n\t\tRENTAL TERMS AND CONDITIONS\n\n" +
        "1. The RENTER shall keep and maintain the rented equipment during the terms of the rental at his own cost and expense. He shall keep the equipment in a good state of repair, normal wear and tear excepted.\n\n" +
        "2. The RENTER shall pay the OWNER full compensation for replacement for replacement and/or repair of any equipment which is not returned because it is lost or stolen or any equipment which is damaged and in need of repair to put it into the same condition it was in at the time of rental, normal wear and tear excepted. The OWNER’s invoice for replacement or repair is conclusive as to the amount RENTER shall pay under this paragraph for repair or replacement.\n\n" +
        "3. The RENTER shall not remove the equipment from the address of the RENTER or the location shown herein as the place of use of the equipment without prior written approval of the OWNER. The RENTER shall inform the OWNER upon demand of the exact location of the equipment while it is in the RENTERS’s possession.\n\n" +
        "4. The equipment shall be delivered to RENTER and returned to OWNER at the RENTER’s risk, cost and expense. If a periodic rental rate is charged by OWNER, rental charges are billed to the RENTER for each period or portions of the period form the time the equipment is delivered to RENTER until its return. If a term rental rate is charged by OWNER, rental charges are billed to the RENTER for the full term even if the equipment is returned before the end of the term. If the equipment is not returned during or at the end of the term, then the rental charges shall continue on a full term basis for any additional term or portion thereof until the equipment is returned.\n\n" +
        "5. No allowance will be made for any rented equipment or portion thereof which is claimed not to have been used. Acceptance of returned equipment by OWNER does not constitute a waiver of any of the rights OWNER has under the rental agreement.\n\n" +
        "6. The RENTER shall allow OWNER to enter RENTER’s premises where the rented equipment is stored or used at all reasonable times to locate and inspect the state and condition of the rented equipment. If the RENTER is in default of any of the terms and conditions of this agreement, the OWNER, and his agents, at the RENTER’s risk, cost and expense may at any time enter the RENTER’s premises where the rented equipment is stored or used at all time and recover the rented equipment.\n\n" +
        "7. The RENTER shall not pledge or encumber the rented equipment in any way. The OWNER may terminate this agreement immediately upon the failure of RENTER to make rental payments when due, or upon RENTER’s filling for protection from creditors in any court of competent jurisdiction.\n\n" +
        "8. The OWNER makes no warranty of any kind regarding the rented equipment, except that OWNER shall replace the equipment with identical or similar equipment if the equipment fails to operate in accordance with the manufacturer’s specifications and operation instructions. Such replacement shall be made as soon as practicable after RENTER returns the non-conforming equipment.\n\n" +
        "9. RENTER indemnifies and holds OWNER harmless for all injuries or damage of any kind for repossession and for all consequential and special damages for any claimed breach of warranty.\n\n" +
        "10. The RENTER shall pay all reasonable attorney and other fees, the expenses and costs incurred by OWNER in protection its rights under this rental agreement and for any action taken OWNER to collect any amounts due the OWNER under this rental agreement.\n\n" +
        "11. These terms are accepted by the RENTER upon delivery of the terms to the RENTER or the  agent or other representative of RENTER.\n\n" +
            "By my signature I acknowledge that I have received a copy of this agreement and all above listed items. I have read or heard this contract read aloud, and understand the conditions of the agreement. My signature is my commitment to adhere to these responsibilities and terms."
    
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
        agreementTextView.text = personalString + rentalAgreement
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
        
        let storageRef = Storage.storage().reference().child(user.text! + " -RentalEquipment".trimmingCharacters(in: .whitespaces))
        
        
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



