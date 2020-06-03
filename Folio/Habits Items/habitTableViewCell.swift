//
//  habitTableViewCell.swift
//  Folio
//
//  Created by Kshitiz Sharma on 03/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class habitTableViewCell: UITableViewCell {
    var index = IndexPath(row: 0, section: 0)
    var delegate: habitsVCProtocol?
    var currentCount = 0.0
    var strakCount = 0
    var habitData: habitCardData?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var stepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardBackgroundView.layer.cornerRadius=cornerRadius
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
        //TODO: calculate streak count
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
    }

    @IBAction func stepperChanged(_ sender: UIStepper) {
        currentCount=stepper.value
        delegate?.changeHabitCurentCount(at: index, to: currentCount)
//        awakeFromNib()
    }
    

}
extension habitTableViewCell{
    var cornerRadius: CGFloat{
        return 15
    }
}
