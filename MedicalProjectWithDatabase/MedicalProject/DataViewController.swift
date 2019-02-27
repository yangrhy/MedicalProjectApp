//
//  DataViewController.swift
//  MedicalProject
//
//  Created by Ashley on 2/5/19.
//

import UIKit
import Firebase

class DataViewController: UIViewController{
    
    var ThermometerPassed = ""
    var SyringePassed = ""
    var NebuilzerPassed = ""
    var PulseOximeterPassed = ""
    var BloodGlucosePassed = ""
    var WalkerPassed = ""
    var InfusionPassed = ""
    var IvSolutionPassed = ""
    var BedPassed = ""
    
    var type = ""

    var customerInfo: DatabaseReference!
    
    @IBOutlet weak var CustomerName: UITextField!
    
    @IBOutlet weak var CustomerAddress: UITextField!
    
    
    
    @IBAction func submitInfo(_ sender: Any) {
        updateInfo()
    }
    
    
    @IBOutlet weak var Date: UIDatePicker!
    
    
    @IBOutlet weak var Time: UIDatePicker!
    
    
    
    @IBOutlet weak var phoneNumber: UITextField!
   
    
    @IBOutlet weak var purchaseSw: UISwitch!
    
    @IBOutlet weak var rentSw: UISwitch!
    
    @IBOutlet weak var returnLabel: UILabel!
    
    @IBAction func purchasedSwitch(_ sender: UIButton) {
        if (purchaseSw.isOn == true){
            type = "Purchased"
        }
        
    }
    
    
    @IBAction func rentedSwitch(_ sender: UIButton) {
        if (rentSw.isOn == true){
            returnDate.isHidden = false
            returnLabel.isHidden = false
            type = "Rented"
        }
        else{
            returnDate.isHidden = true
            returnLabel.isHidden = true
        }
    }
   
    
    @IBOutlet weak var returnDate: UIDatePicker!
    
    
    var ch = ""
    let choices = ["Rented", "Purchased"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchaseSw.isOn = false
        rentSw.isOn = false
        
        customerInfo = Database.database().reference().child("customer");
        
        //self.picker.delegate = self
        //self.picker.dataSource = self
        
 
        
    }
    

    
    
    
    func updateInfo(){
        
        // First we need to create a new instance of the NSDateFormatter
        let dateFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        dateFormatter.dateFormat = "dd-MM-YYYY"
        // Now we get the date from the UIDatePicker and convert it to a string
        let strDate = dateFormatter.string(from: Date.date)
        
        
        // First we need to create a new instance of the NSDateFormatter
        let returnDateFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        returnDateFormatter.dateFormat = "dd-MM-YYYY"
        // Now we get the date from the UIDatePicker and convert it to a string
        let retDate = returnDateFormatter.string(from: returnDate.date)
        
        
        // First we need to create a new instance of the NSDateFormatter
        let timeFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        timeFormatter.dateFormat = "HH:mm a"
        // Now we get the time from the UIDatePicker and convert it to a string
        let strTime = timeFormatter.string(from: Time.date)
        
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        
        
        
        
        let key = customerInfo.childByAutoId().key
        
        
        if (rentSw.isOn == true){
        let customer = ["id":key,
                        "customerName": CustomerName.text! as String,
                        "customerAddress": CustomerAddress.text! as String,
                        "date": strDate,
                        "time": strTime,
                        "type" : type,
                        "returnDate" : retDate,
                        "customerNumber": phoneNumber.text! as String,
                        "Thermometer": ThermometerPassed,
                        "Syringe": SyringePassed,
                        "Nebulizer" : NebuilzerPassed,
                        "PulseOximeter": PulseOximeterPassed,
                        "BloodGlucoseMontior": BloodGlucosePassed,
                        "Walker": WalkerPassed,
                        "InfusionPump" : InfusionPassed,
                        "IVSolution" : IvSolutionPassed,
                        "Bed" : BedPassed]
            
            customerInfo.child(key!).setValue(customer)
        }
        else {
            let customer = ["id":key,
                            "customerName": CustomerName.text! as String,
                            "customerAddress": CustomerAddress.text! as String,
                            "date": strDate,
                            "time": strTime,
                            "type" : type,
                            "customerNumber": phoneNumber.text! as String,
                            "Thermometer": ThermometerPassed,
                            "Syringe": SyringePassed,
                            "Nebulizer" : NebuilzerPassed,
                            "PulseOximeter": PulseOximeterPassed,
                            "BloodGlucoseMontior": BloodGlucosePassed,
                            "Walker": WalkerPassed,
                            "InfusionPump" : InfusionPassed,
                            "IVSolution" : IvSolutionPassed,
                            "Bed" : BedPassed]
            
            customerInfo.child(key!).setValue(customer)
        }
        
        
        // reset fields -RY and give popup message that info has been updated
        
        // create the alert
        let alert = UIAlertController(title: "Equipment Form", message: "Information has been updated.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        // clear fields for another entry
        CustomerName.text = ""
        CustomerAddress.text = ""
        phoneNumber.text = ""
        
    }
    
    
    
    
    
}

