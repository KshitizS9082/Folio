//
//  SwitchPageTimelineViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 13/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol timelineSwitchDelegate {
    func switchToPageAndShowCard(with uniqueID: UUID)
}

class SwitchPageTimelineViewController: UIViewController {
    var page=PageData()
    var index=0
    var myViewController: PageListViewController?
    
//    var segmentControl = UISegmentedControl(items: ["Page", "Timeline"])
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var navBarRightLeftButton: UIBarButtonItem!
    @IBOutlet weak var navBarRightRightButton: UIBarButtonItem!
    
    @IBOutlet weak var pageCV: UIView!
    @IBOutlet weak var timeLineCV: UIView!
    
    var pageVController : PageViewController?
    var timeLineVController : TimelineViewController?
    
    var toolBarIsHidden=false
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        print("segment changed")
        switch segmentControl.selectedSegmentIndex {
        case 0:
            timeLineVController?.save()
//            pageVController?.viewWillAppear(true)
            pageVController?.page=timeLineVController?.page
//            pageVController?.viewDidLoad()
            pageCV.isHidden=false
            timeLineCV.isHidden=true
        case 1:
            //TODO: currently loads data in segment 2 from storage can be done faster
            pageVController?.save()
            pageCV.isHidden=true
            timeLineCV.isHidden=false
            timeLineVController?.viewWillAppear(true)
//            timeLineVController?.viewDidLoad()
        default:
            print("unknown index for segmentControl.selectedSegmentIndex: \(segmentControl.selectedSegmentIndex)")
            break
        }
    }
    
    
    private func configureNavBar(){
        
    }
    @objc private func showToolBar(){
        print("show tool bar")
    }
    @objc private func timeLineToolBar(){
        print("timelint toolBar click")
    }
    @objc private func addTimelineSmallCard(){
        print("show tool bar")
    }
    @objc private func saveFromPageView(){
        print("show tool bar")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        switch segmentControl.selectedSegmentIndex{
        case 0:
            pageVController?.save()
        case 1:
            timeLineVController?.save()
        default:
            print("dont know what to save")
        }
    }
    

    
//     MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pageViewSegue":
            pageVController = segue.destination as? PageViewController
        case "timeLineSegue":
            timeLineVController = segue.destination as? TimelineViewController
            timeLineVController?.myViewController=self
        default:
            print("unknown segue identifier")
        }
        
    }
    

}

extension SwitchPageTimelineViewController: timelineSwitchDelegate{
    func switchToPageAndShowCard(with uniqueID: UUID) {
        segmentControl.selectedSegmentIndex=0
        segmentChanged(segmentControl)
        pageVController?.scrollToCard(with: uniqueID)
    }
    
}
