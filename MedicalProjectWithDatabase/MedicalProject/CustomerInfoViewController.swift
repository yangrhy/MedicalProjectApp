//
//  CustomerInfoViewController.swift
//  MedicalProject
//
//


import UIKit
import Firebase

class CustomerInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var customerInfo: DatabaseReference!
    var customerList = [Customers]()
    
    @IBOutlet weak var customerTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerTableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;

        let eachCustomer:Customers
        eachCustomer = customerList[indexPath.row]
        
        let customerInfoString: String?
        var equipmentString = ""
        var locationString = ""
        
        for (key, value) in eachCustomer.equipment {
            equipmentString += ("\n\(key): \(value)")
        }
        
        for (key, value) in eachCustomer.location {
            if ((key.lowercased() == "Street".lowercased()) ||
                (key.lowercased() == "City".lowercased()) ||
                (key.lowercased() == "Country".lowercased())) {
                    locationString += ("\n\(key): \(value)")
            }
        }
        
        customerInfoString = "Customer Name: \(eachCustomer.custName!)\n\(locationString)\nCustomer Number: \(eachCustomer.custNum!)\nDelivery Date: \(eachCustomer.deliv!)\nDelivery Time: \(eachCustomer.time!)\nPurchase Type: \(eachCustomer.type!)\nEquipment Info:\(equipmentString)"

        cell.textLabel?.text = customerInfoString
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customerTableView.delegate = self
        customerTableView.dataSource = self

        customerInfo = Database.database().reference().child("customer")
        
        customerInfo?.observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            for customers in snapshot.children.allObjects as! [DataSnapshot] {
                let custObj = customers.value as? [String: AnyObject]
                let custName = custObj?["customerName"]
                let location = custObj?["location"]
                let custNum = custObj?["customerNumber"]
                let delivDate = custObj?["date"]
                let delivTime = custObj?["time"]
                let purchType = custObj?["type"]
                let equipment = custObj?["equipment"]
                
                let customer = Customers(custName: custName as! String?, custNum: custNum as! String?, deliv: delivDate as! String?, time: delivTime as! String?, type: purchType as! String?, location: location as! [String: Any], equipment: equipment as! [String: Any])
                
                self.customerList.append(customer)
            }
            self.customerTableView?.reloadData()
        }
    }
    
}
