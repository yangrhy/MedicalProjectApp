//
//  CustomerInfoTableView.swift
//  MedicalProject
//
//  Created by Ricky Yang on 2/9/19.
//

import UIKit
import Firebase

class CustomerInfoTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var customerInfo: DatabaseReference!
    
    @IBOutlet weak var custInfo: UITableView!
    @IBOutlet weak var custName: UILabel!
    @IBOutlet weak var custAddress: UILabel!
    @IBOutlet weak var delivDate: UILabel!
    @IBOutlet weak var delivTime: UILabel!
    @IBOutlet weak var delivStatus: UILabel!
    
    var custList = [Customers]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.custList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.custList.dequeueReusableCell(withIdentifier: "cell", for: IndexPath)
            as! CustomerTableViewCell
        
        let customer: Customers
        
        customer = custList[indexPath.row]
        cell.custName
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerInfo = Database.database().reference().child("customer");
        self.custInfo.register(UITableViewCell.self, forCellReuseIdentifier: <#T##String#>)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
