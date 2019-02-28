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
        
        for (key, value) in eachCustomer.equipment {
            equipmentString += ("\n\(key): \(value)")
        }
        
        customerInfoString = "Customer Name: \(eachCustomer.custName!)\nCountry: \(eachCustomer.country!)\nCity: \(eachCustomer.city!)\nStreet: \(eachCustomer.street!)\nCustomer Number: \(eachCustomer.custNum!)\nDelivery Date: \(eachCustomer.deliv!)\nDelivery Time: \(eachCustomer.time!)\nPurchase Type: \(eachCustomer.type!)\nEquipment Info:\(equipmentString)"

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
                let custCountry = custObj?["country"]
                let custCity = custObj?["city"]
                let custStreet = custObj?["street"]
                
                let custNum = custObj?["customerNumber"]
                let delivDate = custObj?["date"]
                let delivTime = custObj?["time"]
                let purchType = custObj?["type"]
                let equipment = custObj?["eqipment"]
                
                
                let customer = Customers(custName: custName as! String?, custNum: custNum as! String?, deliv: delivDate as! String?, time: delivTime as! String?, type: purchType as! String?, country: custCountry as! String?, city: custCity as! String?, street: custStreet as! String?, equipment: equipment as! [String: Any])
                                         
                self.customerList.append(customer)
            }
            self.customerTableView?.reloadData()
        }
    }
    
}
