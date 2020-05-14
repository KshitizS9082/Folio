//
//  SwitchPageTimelineViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 13/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

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
    
    var toolBarIsHidden=false
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        print("segment changed")
        switch segmentControl.selectedSegmentIndex {
        case 0:
            pageCV.isHidden=false
            timeLineCV.isHidden=true
        case 1:
            pageCV.isHidden=true
            timeLineCV.isHidden=false
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
