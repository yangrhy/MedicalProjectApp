//
//  CalendarViewController.swift
//  
//
//  Created by Ricky Yang on 2/14/19.
//

import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController {
    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!

    @IBOutlet weak var deliveryTableView: UITableView!
    
    var deliveryList = [Customers]()
    
    var deliveryInfo: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        // Do any additional setup after loading the view.
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveData (date: Date) {
        let dateFormatter = DateFormatter()
        // Now we specify the display format, e.g. "27-08-2015
        dateFormatter.dateFormat = "dd-MM-YYYY"
        // Now we get the date from the UIDatePicker and convert it to a string
        
        deliveryInfo = Database.database().reference().child("customer")
        
        
        deliveryInfo?.observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            for customers in snapshot.children.allObjects as! [DataSnapshot] {
                let custObj = customers.value as? [String: AnyObject]
                if (custObj?["date"] as? String == dateFormatter.string(from: date)){
                    let custName = custObj?["customerName"]
                    let custAddress = custObj?["customerAddress"]
                    let custNum = custObj?["customerNumber"]
                    let choice = custObj?["choice"]
                    let delivDate = custObj?["date"]
                    let delivTime = custObj?["time"]
                    let delivStatus = custObj?["status"]
                    
                    let customer = Customers(custName: custName as! String?, custAddy: custAddress as! String?, custNum: custNum as! String?, choice: choice as! String?, deliv: delivDate as! String?, time: delivTime as! String?, delivStat: delivStatus as! String?)
                    
                    self.deliveryList.append(customer)
                }
            }
            self.deliveryTableView?.reloadData()
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
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarLabels(from: visibleDates)
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryCell", for: indexPath) as! CustomerTableViewCell
        
        // allows new line for each string of information
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        let eachCustomer:Customers
        eachCustomer = deliveryList[indexPath.row]
        
        let customerInfoString: String?
        
        customerInfoString = "Delivery Time: \(eachCustomer.time!)\nDelivery Date: \(eachCustomer.deliv!)\nCustomer Name: \(eachCustomer.custName!)\nCustomer Address: \(eachCustomer.custAddy!)\nCustomer Number: \(eachCustomer.custNum!)\nEquipment Type: \(eachCustomer.choice!)\nDelivery Status: \(eachCustomer.delivStat!)"
        
        cell.textLabel?.text = customerInfoString
        
        return cell
    }
}
