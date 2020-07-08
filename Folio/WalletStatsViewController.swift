//
//  WalletStatsViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 06/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import Charts

class WalletStatsViewController: UIViewController {
    var walletData = WalletData()
    var walletEntryArray = [(Date, [walletEntry])]()
    func setupData(){
        walletEntryArray = Array(self.walletData.entries)
        walletEntryArray.sort { (first, second) -> Bool in
            return first.0<second.0
        }
        for ind in self.walletEntryArray.indices{
            self.walletEntryArray[ind].1.sort { (first, second) -> Bool in
                return first.date<second.date
            }
        }
        table.reloadData()
        if startDate==nil && endDate==nil && self.walletData.entries.keys.count>=2{
            if let min=self.walletData.entries.keys.min(), let max=self.walletData.entries.keys.max(){
                startDate=min
                endDate=max
            }
        }
    }
    var startDate: Date?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if let date = startDate{
                self.startDateLabel.text = formatter.string(from: date)
                table.reloadData()
            }
        }
    }
    var endDate: Date?{
        didSet{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            if let date = endDate{
                self.endDateLabel.text = formatter.string(from: date)
                table.reloadData()
            }
        }
    }
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource=self
            table.delegate=self
        }
    }
    @IBOutlet weak var startDateLabel: UILabel!{
        didSet{
            startDateLabel.isUserInteractionEnabled=true
            startDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startDateSelector)))
        }
    }
    @objc func startDateSelector(){
        print("start date selection")
        let myDatePicker: UIDatePicker = UIDatePicker()
        // setting properties of the datePicker
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.datePickerMode = .date
        let alertController = UIAlertController(title: "Scroll To Date\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        if let date = startDate{
            myDatePicker.setDate(date, animated: false)
        }
        let somethingAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            DispatchQueue.main.async {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                self.startDate=myDatePicker.date
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        alertController.view.addSubview(myDatePicker)
        myDatePicker.translatesAutoresizingMaskIntoConstraints=false
        [
            myDatePicker.topAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            myDatePicker.heightAnchor.constraint(equalToConstant: 170),
            //            myDatePicker.bottomAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            myDatePicker.centerXAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            myDatePicker.widthAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.widthAnchor, constant: -20)
            ].forEach { (cst) in
                cst.isActive=true
        }
        self.present(alertController, animated: true, completion:{})
    }
    @IBOutlet weak var endDateLabel: UILabel!{
        didSet{
            endDateLabel.isUserInteractionEnabled=true
            endDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endDateSelector)))
        }
    }
    @objc func endDateSelector(){
        print("start date selection")
        let myDatePicker: UIDatePicker = UIDatePicker()
        // setting properties of the datePicker
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.datePickerMode = .date
        let alertController = UIAlertController(title: "Scroll To Date\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        if let date = endDate{
            myDatePicker.setDate(date, animated: false)
        }
        let somethingAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            DispatchQueue.main.async {
                self.endDate=myDatePicker.date
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        alertController.view.addSubview(myDatePicker)
        myDatePicker.translatesAutoresizingMaskIntoConstraints=false
        [
            myDatePicker.topAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            myDatePicker.heightAnchor.constraint(equalToConstant: 170),
            myDatePicker.centerXAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            myDatePicker.widthAnchor.constraint(equalTo: alertController.view.safeAreaLayoutGuide.widthAnchor, constant: -20)
            ].forEach { (cst) in
                cst.isActive=true
        }
        self.present(alertController, animated: true, completion:{})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue ,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("walletData.json"){
            if let jsonData = try? Data(contentsOf: url){
                if let extract = WalletData(json: jsonData){
                    print("did set self.habits to \(extract)")
                    self.walletData = extract
                    self.setupData()
                }else{
                    print("ERROR: found WalletData(json: jsonData) to be nil so didn't set it")
                }
            }else{
                print("error no file named walletData.json found")
            }
        }
        
    }
}

extension WalletStatsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: "balGraphIdentifier") as! balanceGraphTableViewCell
             cell.walletData=self.walletData
             cell.startDate=self.startDate
             cell.endDate=self.endDate
             cell.setupChartData()
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            return cell
        }
    }
    
    
}

class balanceGraphTableViewCell: UITableViewCell,ChartViewDelegate {
    @IBOutlet weak var cardBackgroundView: UIView!{
        didSet{
            cardBackgroundView.layer.cornerRadius=15
            //Draw shaddow for layer
            cardBackgroundView.layer.shadowColor = UIColor.gray.cgColor
            cardBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cardBackgroundView.layer.shadowRadius = 5.0
            cardBackgroundView.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet weak var lineChartView: LineChartView!{
        didSet{
            self.lineChartView.backgroundColor = UIColor(named: "smallCardColor")
//            self.lineChartView.layer.cornerRadius = chartCornerRadius
//            self.lineChartView.layer.masksToBounds = false
//            self.lineChartView.layer.shadowColor = UIColor.gray.cgColor
//            self.lineChartView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//            self.lineChartView.layer.shadowRadius = 5.0
//            self.lineChartView.layer.shadowOpacity = 0.4
            
            self.lineChartView.delegate = self
            self.lineChartView.rightAxis.gridColor = .clear
            
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
    var yValues = [ChartDataEntry]()
    var startDate: Date?
    var endDate: Date?
    var walletData = WalletData()
    func setupChartData(){
        yValues.removeAll()
        if let start=startDate, let end=endDate{
            for entry in walletData.entries{
                if entry.key>=start.startOfDay && entry.key<=end.startOfDay{
                    var sum=Float(0.0)
                    for val in entry.value{
                        sum+=val.value
                    }
                    self.yValues.append(ChartDataEntry(x: entry.key.timeIntervalSince1970, y: Double(sum)))
                }
            }
            self.yValues.sort { (first, secon) -> Bool in
                return first.x<secon.x
            }
            for ind in self.yValues.indices{
                if ind>0{
                    self.yValues[ind].y+=self.yValues[ind-1].y
                }
            }
            print("set data to \(self.yValues)")
            
            //Date of entrieds
            let set1 = LineChartDataSet(entries: self.yValues, label: "Date")
            set1.drawCirclesEnabled=false
            set1.mode = .stepped
            set1.lineWidth = 3
            set1.setColor(.systemPink)
            
            let gradientColors = [UIColor.systemPink.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
            let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            set1.drawFilledEnabled = true // Draw the Gradient
            
            let data = LineChartData(dataSet: set1)
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 1
            numberFormatter.locale = Locale.current
            let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
            set1.valueFormatter = valuesNumberFormatter
            
            data.setValueTextColor(UIColor(named: "subMainTextColor") ?? UIColor.red)
            data.setValueFont(.boldSystemFont(ofSize: 10))
            lineChartView.data = data
            
            lineChartView.xAxis.valueFormatter = DateValueFormatter()
            lineChartView.notifyDataSetChanged()
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
extension balanceGraphTableViewCell{
    var cornerRadius: CGFloat{
        return 15
    }
    var fullCalHeight: CGFloat{
        return 400
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
    var chartHeight: CGFloat{
        return 175
    }
}
public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd/M"
    }
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

