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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupCalendarView() {
        // calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
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
        
        let startDate = Date()
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
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarLabels(from: visibleDates)
    }
}
