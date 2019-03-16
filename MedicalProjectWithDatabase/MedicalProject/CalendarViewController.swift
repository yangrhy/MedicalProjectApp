//
//  CalendarViewController.swift
//  MedicalProject
//
//


import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController {
    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var returnTableView: UITableView!
    @IBOutlet weak var deliveryTableView: UITableView!
    
    var deliveryList = [Customers]()
    var returnList = [Customers]()
    
    var deliveryInfo: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        
        returnTableView.delegate = self
        returnTableView.dataSource = self

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveData (date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        
        deliveryInfo = Database.database().reference().child("customer")
        
        deliveryInfo?.observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            for customers in snapshot.children.allObjects as! [DataSnapshot] {
                let custObj = customers.value as? [String: AnyObject]
                
                if (custObj?["date"] as? String == dateFormatter.string(from: date)){
                    let custName = custObj?["customerName"]
                    let location = custObj?["location"]
                    let custNum = custObj?["customerNumber"]
                    let delivDate = custObj?["date"]
                    let delivTime = custObj?["time"]
                    let purchType = custObj?["type"]
                    let equipment = custObj?["equipment"]
                    
                    let customer = Customers(custName: custName as! String?, custNum: custNum as! String?, deliv: delivDate as! String?, time: delivTime as! String?, type: purchType as! String?, location: location as! [String: Any], equipment: equipment as! [String: Any])
                    
                    self.deliveryList.append(customer)
                }
                
                if (custObj?["returnDate"] as? String == dateFormatter.string(from: date)){
                    let custName = custObj?["customerName"]
                    let location = custObj?["location"]
                    let custNum = custObj?["customerNumber"]
                    let equipment = custObj?["equipment"]
                    let returnDate = custObj?["returnDate"]
                    
                    let customer = Customers(custName: custName as! String?, custNum: custNum as! String?, returnDate: returnDate as! String?, location: location as! [String: Any], equipment: equipment as! [String: Any])
                    
                    self.returnList.append(customer)
                }
            }
            self.deliveryTableView?.reloadData()
            self.returnTableView?.reloadData()
        }
    }
    func setupCalendarView() {
        // calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        // Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupCalendarLabels(from: visibleDates)
        }
        
    }
    
    // Initialization of month and year labels upon first open
    func setupCalendarLabels (from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    // controls display of what day is selected
    func handleSelectedCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CustomCell else { return }
        if cellState.isSelected {
            cell.viewSelected.isHidden = false
            
            // make a call here to a created function for listing information into dataviewtable to show delivery schedule
            retrieveData(date: cellState.date)
            
        }
        else {
            cell.viewSelected.isHidden = true
        }
    }
    
    // gray out of days do not belong to the current month
    func handleCellDateColor(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            cell.dateLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
        else {
            if cellState.dateBelongsTo == .thisMonth {
                cell.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else {
                cell.dateLabel.textColor = #colorLiteral(red: 0.4912299313, green: 0.6373919675, blue: 0.8439119171, alpha: 1)
            }
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2019 1 1")!
        let endDate = formatter.date(from: "2019 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}
extension CalendarViewController: JTAppleCalendarViewDelegate {
    // need both functions to display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.dateLabel.text = cellState.text
        handleSelectedCell(view: cell, cellState: cellState)
        handleCellDateColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCell
        myCustomCell.dateLabel.text = cellState.text
        handleSelectedCell(view: cell, cellState: cellState)
        handleCellDateColor(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleSelectedCell(view: cell, cellState: cellState)
        handleCellDateColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleSelectedCell(view: cell, cellState: cellState)
        handleCellDateColor(view: cell, cellState: cellState)
        deliveryList.removeAll()
        returnList.removeAll()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarLabels(from: visibleDates)
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.deliveryTableView {
            count = deliveryList.count
        }
        
        if tableView == self.returnTableView {
            count = returnList.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.deliveryTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "deliveryCell", for: indexPath) as! CustomerTableViewCell
            
            // allows new line for each string of information
            cell!.textLabel?.numberOfLines = 0
            cell!.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            
            let eachCustomer:Customers
            eachCustomer = deliveryList[indexPath.row]
            
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
            
            cell!.textLabel?.text = customerInfoString
            
        }
        
        if tableView == self.returnTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "returnCell", for: indexPath) as! CustomerTableViewCell
            
            // allows new line for each string of information
            cell!.textLabel?.numberOfLines = 0
            cell!.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
            
            let eachCustomer:Customers
            eachCustomer = returnList[indexPath.row]
            
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
            
            customerInfoString = "Customer Name: \(eachCustomer.custName!)\n\(locationString)\nCustomer Number: \(eachCustomer.custNum!)\nReturn Date: \(eachCustomer.returnDate!)\nEquipment Info:\(equipmentString)"
            
            cell!.textLabel?.text = customerInfoString
            
        }
        return cell!
    }
}
