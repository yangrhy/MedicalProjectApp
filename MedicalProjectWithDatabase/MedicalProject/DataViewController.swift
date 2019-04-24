//
//  DataViewController.swift
//  MedicalProject
//
//


import UIKit
import Firebase
import CoreLocation
import FirebaseDatabase

class DataViewController: UIViewController{
    var equipmentInfo: [String: Any] = [:]
    var locationInfo: [String: Any] = [:]
    var type = ""
    var lat = ""
    var long = ""
    var customerInfo: DatabaseReference!
    
    @IBOutlet weak var CustomerName: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBAction func submitInfo(_ sender: Any) {
        guard let country = countryTextField.text else { return }
        guard let street = streetTextField.text else { return }
        guard let city = cityTextField.text else { return }
        
        let address = "\(country), \(city), \(street)"
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        self.navigationController?.popToRootViewController(animated: true)
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
            rentSw.isOn = false
            returnDate.isHidden = true
            returnLabel.isHidden = true
        }
        
    }
    
    @IBAction func rentedSwitch(_ sender: UIButton) {
        if (rentSw.isOn == true){
            returnDate.isHidden = false
            returnLabel.isHidden = false
            type = "Rented"
            purchaseSw.isOn = false
        }
        else{
            returnDate.isHidden = true
            returnLabel.isHidden = true
        }
    }
   
    @IBOutlet weak var returnDate: UIDatePicker!
    
    lazy var geocoder = CLGeocoder()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    var ch = ""
    let choices = ["Rented", "Purchased"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purchaseSw.isOn = false
        rentSw.isOn = false
        
        customerInfo = Database.database().reference().child("customer");
        
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate

                lat = "\(coordinate.latitude)"
                long = "\(coordinate.longitude)"
                
            } else {
                lat = "No Matching Location Found"
                long = "No Matching Location Found"
                
            }
        }
        locationInfo["Street"] = streetTextField.text
        locationInfo["City"] = cityTextField.text
        locationInfo["Country"] = countryTextField.text
        locationInfo["Street"] = streetTextField.text
        locationInfo["Latitude"] = lat
        locationInfo["Longitude"] = long

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let strDate = dateFormatter.string(from: Date.date)
        
        let returnDateFormatter = DateFormatter()
        returnDateFormatter.dateFormat = "dd-MM-YYYY"
        let retDate = returnDateFormatter.string(from: returnDate.date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm a"
        let strTime = timeFormatter.string(from: Time.date)
        
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        
        let key = customerInfo.childByAutoId().key
        
        if (rentSw.isOn == true){
        let customer = ["id":key,
                        "customerName": CustomerName.text! as String,
                        "location": locationInfo as [String:Any],
                        "date": strDate,
                        "time": strTime,
                        "type" : type,
                        "returnDate" : retDate,
                        "customerNumber": phoneNumber.text! as String,
                        "equipment" : equipmentInfo] as [String : Any]

            customerInfo.child(key!).setValue(customer)
        }
        else {
            let customer = ["id":key,
                            "customerName": CustomerName.text! as String,
                            "location": locationInfo as [String:Any],
                            "date": strDate,
                            "time": strTime,
                            "type" : type,
                            "customerNumber": phoneNumber.text! as String,
                            "equipment" : equipmentInfo] as [String : Any]
            
            customerInfo.child(key!).setValue(customer)
        }
        
        let alert = UIAlertController(title: "Equipment Form", message: "Information has been updated.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        CustomerName.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        streetTextField.text = ""
        phoneNumber.text = ""
        
    }
    
}

