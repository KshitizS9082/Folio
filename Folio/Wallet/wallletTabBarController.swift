//
//  wallletTabBarController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 02/07/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class wallletTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        // Do any additional setup after loading the view.
    }
    
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
        
        //STYLE THE BUTTON YOUR OWN WAY
//        middleBtn.setIcon(icon: .fontAwesomeSolid(.home), iconSize: 20.0, color: UIColor.white, backgroundColor: UIColor.white, forState: .normal)
//        middleBtn.applyGradient(colors: colorBlueDark.cgColor,colorBlueLight.cgColor])
        middleBtn.setImage( UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)), for: .normal)
        middleBtn.layer.cornerRadius = middleBtn.layer.bounds.width/2.0
        middleBtn.backgroundColor = .systemTeal
        middleBtn.tintColor = UIColor.systemBackground
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    @IBOutlet weak var rightButton: UINavigationItem!
    @IBAction func handleRightRightButton(_ sender: Any) {
        if let vc = self.viewControllers?.first as? walletViewController{
            vc.showDateSelctor()
        }
    }
    
    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
//        self.selectedIndex = 1   //to select the middle tab. use "1" if you have only 3 tabs.
        if let vc = self.viewControllers?.first as? walletViewController{
            vc.addEntry()
        }
    }
}
