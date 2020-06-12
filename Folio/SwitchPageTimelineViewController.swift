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
    var pageID: pageInfo?
    var page=PageData()
    var index=0
    var myViewController: PageListViewController?
    
//    var segmentControl = UISegmentedControl(items: ["Page", "Timeline"])
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var navBarRightLeftButton: UIBarButtonItem!
    @IBOutlet weak var navBarRightRightButton: UIBarButtonItem!
    
    
    @IBAction func leftButtonClick(_ sender: UIBarButtonItem) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("lfb 0")
//            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
//                print(notificationRequests)
//            }
            self.editPageTap()
        case 1:
            print("lfb 1")
            timeLineToolBar()
        default:
            print("showing timeline so do nothing")
        }
    }
    
    @IBAction func rightButtonClick(_ sender: UIBarButtonItem) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            pageVController?.toggleToolBar()
        case 1:
            print("lfb 1")
            handleAddCardButtton()
        default:
            print("showing timeline so do nothing")
        }
    }
    @IBOutlet weak var pageCV: UIView!
    @IBOutlet weak var timeLineCV: UIView!
    
    var pageVController : PageViewController?
    var timeLineVController : TimelineViewController?
    
    var toolBarIsHidden=false
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        print("segment changed")
        switch segmentControl.selectedSegmentIndex {
        case 0:
            navBarRightRightButton.image = UIImage(systemName: "rectangle.3.offgrid")
            timeLineVController?.save()
            pageVController?.page=timeLineVController?.page
            pageCV.isHidden=false
            timeLineCV.isHidden=true
        case 1:
            navBarRightRightButton.image = UIImage(systemName: "plus")
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
    private func timeLineToolBar(){
        print("timelint toolBar click")
        //        vc2.setShowingCardType()
        let showAll = UIAlertAction(title: "Show All Cards",
                                    style: .default) { (action) in
                                        self.timeLineVController?.showingType = .allCards
                                        self.timeLineVController?.viewDidLoad()
        }
        let showTimed = UIAlertAction(title: "Show Reminder Cards",
                                      style: .default) { (action) in
                                        self.timeLineVController?.showingType = .reminderCards
                                        self.timeLineVController?.viewDidLoad()
        }
        let mediaCards = UIAlertAction(title: "Show Media Cards",
                                       style: .default) { (action) in
                                        self.timeLineVController?.showingType = .mediaTypes
                                        self.timeLineVController?.viewDidLoad()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
                                            // Respond to user selection of the action
        }
        
        let alert = UIAlertController(title: "Sort Cards",
                                      message: "filter what to see",
                                      preferredStyle: .actionSheet)
        alert.addAction(showAll)
        alert.addAction(showTimed)
        alert.addAction(mediaCards)
        alert.addAction(cancelAction)
        // On iPad, action sheets must be presented from a popover.
        alert.popoverPresentationController?.barButtonItem =
            self.navBarRightLeftButton
        self.present(alert, animated: true) {
            // The alert was presented
        }
        
    }
    
    private func handleAddCardButtton(){
            let addSmall = UIAlertAction(title: "Add Small Card",
                                        style: .default) { (action) in
                                             self.timeLineVController?.addTimelineCard(of: .small)
            }
            let addBig = UIAlertAction(title: "Add Big Card",
                                          style: .default) { (action) in
                                            self.timeLineVController?.addTimelineCard(of: .big)
            }
            let addMedia = UIAlertAction(title: "Add Media Card",
                                           style: .default) { (action) in
                                             self.timeLineVController?.addTimelineCard(of: .media)
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel) { (action) in
                                                // Respond to user selection of the action
            }
            
            let alert = UIAlertController(title: "Add Card",
                                          message: "NOTE: You will automatically be switched to View All Card",
                                          preferredStyle: .actionSheet)
            alert.addAction(addSmall)
            alert.addAction(addBig)
            alert.addAction(addMedia)
            alert.addAction(cancelAction)
            // On iPad, action sheets must be presented from a popover.
            alert.popoverPresentationController?.barButtonItem =
                self.navBarRightRightButton
            self.present(alert, animated: true) {
                // The alert was presented
            }
        }
    func editPageTap(){
        let toggleGrids = UIAlertAction(title: "Toggle Grids",
                                     style: .default) { (action) in
                                        self.pageVController?.toggleGridStyle()
        }
        let toggleScroll = UIAlertAction(title: "Toggle Scroll Direction",
                                   style: .default) { (action) in
                                    //                                        self.timeLineVController?.addTimelineCard(of: .big)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
                                            // Respond to user selection of the action
        }
        let alert = UIAlertController(title: "Change page style",
                                      message: "Actions will change how you interact with your page",
                                      preferredStyle: .actionSheet)
        alert.addAction(toggleGrids)
        alert.addAction(toggleScroll)
        alert.addAction(cancelAction)
        // On iPad, action sheets must be presented from a popover.
        alert.popoverPresentationController?.barButtonItem =
            self.navBarRightLeftButton
        self.present(alert, animated: true) {
            // The alert was presented
        }
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        
        switch segmentControl.selectedSegmentIndex{
        case 0:
            pageVController?.save()
        case 1:
            timeLineVController?.save()
        default:
            print("dont know what to save")
        }
    }
    
    //to show a card on segue
    var uniqueIdOfCardToShow: UUID? //shows a card when uuid not nill and then set it to nill
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("inside view did appear")
        if let id =  uniqueIdOfCardToShow{
            self.switchToPageAndShowCard(with: id)
            self.uniqueIdOfCardToShow=nil
        }
    }
//     MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pageViewSegue":
            pageVController = segue.destination as? PageViewController
            pageVController?.pageID = self.pageID
        case "timeLineSegue":
            timeLineVController = segue.destination as? TimelineViewController
            timeLineVController?.pageID = self.pageID
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
