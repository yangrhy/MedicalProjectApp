//
//  DataViewController.swift
//  MedicalProject
//
//  Created by Ashley on 2/5/19.
//

import UIKit
import Firebase

class DataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var customerInfo: DatabaseReference!
    
    @IBOutlet weak var CustomerName: UITextField!
    
    @IBOutlet weak var CustomerAddress: UITextField!
    
    
    
    @IBAction func submitInfo(_ sender: Any) {
        updateInfo()
    }
    
    
    @IBOutlet weak var Date: UIDatePicker!
    
    
    @IBOutlet weak var Time: UIDatePicker!
    
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    

    @IBOutlet weak var status: UIPickerView!
    
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    var st = ""
    let statusOpt = ["In Progress", "Completed", "Pending", "Not Started"]
    
    var ch = ""
    let choices = ["Rented", "Purchased"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerInfo = Database.database().reference().child("customer");
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        
        self.status.delegate = self
        self.status.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker{
            return choices.count
        }
        return statusOpt.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker {
            ch = choices[row]
            return ch
        }
        
        st = statusOpt[row]
        return st
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, forComponent component: Int) -> String? {
        if (picker.tag == 0) {
            ch = choices[row]
            return ch
        }
        
        st = statusOpt[row]
        return st
        
        
    }
    
    
    func updateInfo(){
        
        // First we need to create a new instance of the NSDateFormatter
        let dateFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        dateFormatter.dateFormat = "dd-MM-YYYY"
        // Now we get the date from the UIDatePicker and convert it to a string
        let strDate = dateFormatter.string(from: Date.date)
        
        
        
        // First we need to create a new instance of the NSDateFormatter
        let timeFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        timeFormatter.dateFormat = "HH:mm a"
        // Now we get the time from the UIDatePicker and convert it to a string
        let strTime = timeFormatter.string(from: Time.date)
        
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        
        
        
        
        let key = customerInfo.childByAutoId().key
        
        let customer = ["id":key,
                        "customerName": CustomerName.text! as String,
                        "customerAddress": CustomerAddress.text! as String,
                        "date": strDate,
                        "time": strTime,
                        "choice": ch,
                        "status" : st,
                        "customerNumber": phoneNumber.text! as String]
        
        customerInfo.child(key!).setValue(customer)
        
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

