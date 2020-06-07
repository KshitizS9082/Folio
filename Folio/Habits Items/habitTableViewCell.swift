//
//  habitTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 03/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Charts

class habitTableViewCell: UITableViewCell {
    var index = IndexPath(row: 0, section: 0)
    var delegate: habitsVCProtocol?
    var currentCount = 0.0
    var strakCount = 0
    var habitData: habitCardData?
    var numberOfRows = 1
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var calendar: JTAppleCalendarView!{
        didSet{
            calendar.ibCalendarDataSource=self
            calendar.ibCalendarDelegate=self
            calendar.layer.cornerRadius = calendarCornerRadius
        }
    }
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toggleCalSizeIV: UIImageView!{
        didSet{
            toggleCalSizeIV.tintColor = UIColor.systemTeal
            toggleCalSizeIV.isUserInteractionEnabled=true
            toggleCalSizeIV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleCalendar)))
        }
    }
    
    var yValues = [ChartDataEntry]()
    @IBOutlet weak var lineChartView: LineChartView!{
        didSet{
            self.lineChartView.backgroundColor = UIColor(named: "myBackgroundColor")
            self.lineChartView.layer.cornerRadius = chartCornerRadius
            self.lineChartView.layer.masksToBounds = true
            self.lineChartView.delegate = self
            self.lineChartView.rightAxis.enabled=false
            
            self.lineChartView.leftAxis.setLabelCount(6, force: true)
            self.lineChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
            self.lineChartView.leftAxis.labelTextColor = .systemTeal
            self.lineChartView.leftAxis.axisLineColor = UIColor(named: "subMainTextColor") ?? UIColor.systemRed
            self.lineChartView.leftAxis.labelPosition = .outsideChart
            
            self.lineChartView.xAxis.labelPosition = .bottom
            self.lineChartView.xAxis.setLabelCount(7, force: false)
            self.lineChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
            self.lineChartView.xAxis.labelTextColor = .systemTeal
            self.lineChartView.xAxis.axisLineColor = UIColor(named: "subMainTextColor") ?? UIColor.systemRed
            
            self.lineChartView.leftAxis.gridColor = .clear
            self.lineChartView.xAxis.gridColor = .clear
            
            self.lineChartView.noDataText = "You need to provide data for the chart."
            self.lineChartView.animate(xAxisDuration: 1.5)
        }
    }
    
    
    var selectedDate = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.isUserInteractionEnabled=true
        self.cardBackgroundView.layer.cornerRadius=cornerRadius
        //set calendar
        calendar.scrollDirection = .horizontal
        calendar.isPagingEnabled=true
        if numberOfRows == 6 {
            self.calendarHeightConstraint.constant = fullCalHeight
            self.toggleCalSizeIV.image = UIImage(systemName: "chevron.up.circle")
        } else {
            self.calendarHeightConstraint.constant = singleRohCalHeight
            self.toggleCalSizeIV.image = UIImage(systemName: "chevron.down.circle")
        }
        self.calendar.reloadData(withanchor: self.selectedDate)
        
        var date = Date()
        titleLabel.text = habitData?.title
        switch habitData?.habitGoalPeriod {
        case .daily:
            currentCountLabel.text = "Today: "
            date=date.startOfDay
        case .weekly:
            currentCountLabel.text = "This Week: "
            date=date.startOfWeek
        case .monthly:
            currentCountLabel.text = "This Month: "
            date=date.startOfMonth
        case .yearly:
            currentCountLabel.text = "This Year: "
            date=date.startOfYear
        default:
            print("ERROR: UNKNOWN HABITGOALPERIOD IN HABITTABLEVIEWCELL")
            currentCountLabel.text = ""
        }
        //TODO: calculate count
        currentCount=habitData?.entriesList[date] ?? 0
        if let gc = habitData?.goalCount{
            currentCountLabel.text! += String(currentCount) + " / " + String(gc)
            stepper.value=currentCount
            //            stepper.maximumValue=gc
        }else{
            currentCountLabel.text! += String(currentCount) + " / y"
        }
        // calculate streak count
        strakCount=0
        if let hdt = habitData{
            if let cnt = hdt.entriesList[date]{
                if (cnt.isLess(than: hdt.goalCount))==false{
                    self.strakCount+=1
                }
            }
            var temp=1
            switch hdt.habitGoalPeriod {
            case .daily:
                date =  Calendar.current.date(byAdding: .day,value: -(temp), to: Date())!.startOfDay
            case .weekly:
                date =  Calendar.current.date(byAdding: .weekOfYear,value:  -(temp), to: Date())!.startOfWeek
            case .monthly:
                date =  Calendar.current.date(byAdding: .month,value:  -(temp), to: Date())!.startOfMonth
            case .yearly:
                date =  Calendar.current.date(byAdding: .year,value: -(temp), to: Date())!.startOfYear
            }
            while(hdt.entriesList[date] != nil ){
                if(hdt.entriesList[date]!.isLess(than: hdt.goalCount)){
                    break
                }else{
                    temp+=1
                }
                //decrease date by that goal period to check if done in last time duration
                switch hdt.habitGoalPeriod {
                case .daily:
                    date =  Calendar.current.date(byAdding: .day,value: -(temp), to: Date())!.startOfDay
                case .weekly:
                    date =  Calendar.current.date(byAdding: .weekOfYear,value:  -(temp), to: Date())!.startOfWeek
                case .monthly:
                    date =  Calendar.current.date(byAdding: .month,value:  -(temp), to: Date())!.startOfMonth
                case .yearly:
                    date =  Calendar.current.date(byAdding: .year,value: -(temp), to: Date())!.startOfYear
                }
            }
            strakCount+=temp-1
        }
        
        streakLabel.text = "Streak: \(strakCount)"
        
        //setup chart
        setupChartData()
    }
    func setupChartData(){
        yValues.removeAll()
        if let hdt = habitData{
            var date = hdt.constructionDate
            var counter = 1.0
            switch hdt.habitGoalPeriod {
            case .daily:
                while(date <= Date()){
                    yValues.append(ChartDataEntry(x: counter, y: hdt.entriesList[date] ?? 0.0))
                    counter += 1.0
                    date = Calendar.current.date(byAdding: .day,value: 1, to: date)!.startOfDay
                }
            default:
                print("yet to handdle")
            }
        }
        let set1 = LineChartDataSet(entries: self.yValues, label: "Count Entry")
        set1.drawCirclesEnabled=false
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.systemPink)
        
//        set1.fill = Fill(color: .systemPink)
//        set1.fillAlpha = 0.6
//        set1.drawFilledEnabled=true
        
        let gradientColors = [UIColor.systemPink.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set1.drawFilledEnabled = true // Draw the Gradient
        
        let data = LineChartData(dataSet: set1)
//        data.setDrawValues(false)
        data.setValueTextColor(UIColor(named: "subMainTextColor") ?? UIColor.red)
        data.setValueFont(.boldSystemFont(ofSize: 10))
        lineChartView.data = data
        
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        currentCount=stepper.value
        delegate?.changeHabitCurentCount(at: index, to: currentCount)
//        awakeFromNib()
    }
    @objc func toggleCalendar(){
        print("inside toggle cal")
//        if numberOfRows==1{
//            self.calendarHeightConstraint.constant=100
//            delegate?.updated(indexpath: index)
//        }else{
        //            self.calendarHeightConstraint.constant=300
        //            delegate?.updated(indexpath: index)
        //        }
        //        awakeFromNib()
        if numberOfRows == 6 {
            self.calendarHeightConstraint.constant = singleRohCalHeight
            self.numberOfRows = 1
            self.toggleCalSizeIV.image = UIImage(systemName: "chevron.down.circle")
        } else {
            self.calendarHeightConstraint.constant = fullCalHeight
            self.numberOfRows = 6
            self.toggleCalSizeIV.image = UIImage(systemName: "chevron.up.circle")
//            UIView.animate(withDuration: 0.2, animations: {
////                self.layoutIfNeeded()
//                self.delegate?.updated(indexpath: self.index)
//                self.calendar.reloadData(withanchor: self.selectedDate)
//            })
            
        }
//        UIView.animate(withDuration: 0.2, animations: {
//            self.layoutIfNeeded()
//            self.delegate?.updated(indexpath: self.index)
//        }) { completed in
//            self.calendar.reloadData(withanchor: self.selectedDate)
//        }
        UIView.animate(withDuration: 0.4, animations: {
                            self.layoutIfNeeded()
            self.delegate?.updated(indexpath: self.index)
            self.calendar.reloadData(withanchor: self.selectedDate)
        })
    }
}
extension habitTableViewCell{
    var cornerRadius: CGFloat{
        return 15
    }
    var fullCalHeight: CGFloat{
        return 500
    }
    var singleRohCalHeight: CGFloat{
        return 100
    }
    var calendarCornerRadius: CGFloat{
        return 15
    }
    var chartCornerRadius: CGFloat{
        return 15
    }
}
extension habitTableViewCell: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}


extension habitTableViewCell: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
     func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
           let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "habitsDateCell", for: indexPath) as! habitsCellCalendarCell
           self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
           //        if cellState.dateBelongsTo == .thisMonth {
           //           cell.isHidden = false
           //        } else {
           //           cell.isHidden = true
           //        }
        if let hdt = habitData{
            var sameDay = false
            switch hdt.habitGoalPeriod {
            case .daily:
                let a = hdt.entriesList[date.startOfDay] ?? 0.0
                cell.countLabel.text = a.description
                sameDay = Calendar.current.isDate(date, equalTo: date.startOfDay, toGranularity: .day)
            case .weekly:
                let a = hdt.entriesList[date.startOfWeek] ?? 0.0
                cell.countLabel.text = a.description
                sameDay = Calendar.current.isDate(date, equalTo: date.startOfWeek, toGranularity: .day)
            case .monthly:
                let a = hdt.entriesList[date.startOfMonth] ?? 0.0
                cell.countLabel.text = a.description
                sameDay = Calendar.current.isDate(date, equalTo: date.startOfMonth, toGranularity: .day)
            case .yearly:
                let a = hdt.entriesList[date.startOfYear] ?? 0.0
                cell.countLabel.text = a.description
                sameDay = Calendar.current.isDate(date, equalTo: date.startOfYear, toGranularity: .day)
            }
            if sameDay{
                print("is first day of categ")
                if hdt.habitGoalPeriod != .daily{
                    cell.contentView.layer.borderColor = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 0.3976947623)
                    cell.contentView.layer.borderWidth = 1
                }
            }else{
                print("is not first day of categ")
                cell.contentView.layer.borderWidth = 0
            }
        }else{
            cell.countLabel.text = "noHdt"
        }
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
//        let startDate = formatter.date(from: "2018 01 01")!
        let startDate = habitData?.constructionDate ??  formatter.date(from: "2018 01 01")!
        let endDate = habitData?.targetDate ?? Calendar.current.date(byAdding: .month, value: 3, to: Date())!
        
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
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
            guard let cell = view as? habitsCellCalendarCell  else { return }
            cell.dateLabel.text = cellState.text
            handleCellTextColor(cell: cell, cellState: cellState)
    //        handleCellSelected(cell: cell, cellState: cellState)
        }
    func handleCellTextColor(cell: habitsCellCalendarCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor(named: "mainTextColor")
        } else {
            cell.dateLabel.textColor = UIColor(named: "subMainTextColor")
        }
    }
    
    //ask if to allow selectinog a cell
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
//        if cellState.dateBelongsTo == .thisMonth{
//            return true
//        }else{
//            return false
//        }
        return false
    }
    
    //set header view
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM YYYY"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "habitDateHeader", for: indexPath) as! habitDateCellHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
}
