//
//  journalViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 25/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import JTAppleCalendar

class JournalViewController: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        constraint.constant=fullCalHeight
        navigationController?.hidesBarsOnSwipe=true
    }
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var toggleCalendarButton: UIBarButtonItem!
    var numberOfRows = 6
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    @IBAction func toggleCalendar(_ sender: Any) {
        if numberOfRows == 6 {
            self.constraint.constant = singleRohCalHeight
            self.numberOfRows = 1
            self.toggleCalendarButton.image = UIImage(systemName: "rectangle.expand.vertical")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { completed in
                //NOTE: did set anchor date to todays date
                self.calendarView.reloadData(withanchor: Date())
            }
        } else {
            self.constraint.constant = fullCalHeight
            self.numberOfRows = 6
            self.toggleCalendarButton.image = UIImage(systemName: "rectangle.compress.vertical")
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.calendarView.reloadData(withanchor: Date())
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let visibleDates = calendarView.visibleDates()
        calendarView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe=false
    }
}
extension JournalViewController{
    var fullCalHeight: CGFloat{
        return 300
    }
    var singleRohCalHeight: CGFloat{
        return 100
    }
    var monthLabelViewSize: CGFloat{
        return 40
    }
}

extension JournalViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = Date()
        
        if numberOfRows == 6 {
            return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows)
        } else {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: numberOfRows,
                                           generateInDates: .forFirstMonthOnly,
                                           generateOutDates: .off,
                                           hasStrictBoundaries: false)
        }
        
    }
}
extension JournalViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        //        if cellState.dateBelongsTo == .thisMonth {
        //           cell.isHidden = false
        //        } else {
        //           cell.isHidden = true
        //        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius =  20
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo == .thisMonth{
            return true
        }else{
            return false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM YYYY"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: monthLabelViewSize)
    }
}
