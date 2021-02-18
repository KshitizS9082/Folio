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
        //setting darkmode/lightmode/automode
        let interfaceStyle = UserDefaults.standard.integer(forKey: "prefs_is_dark_mode_on")
        if interfaceStyle==0{
            overrideUserInterfaceStyle = .unspecified
        }else if interfaceStyle==1{
            overrideUserInterfaceStyle = .light
        }else if interfaceStyle==2{
            overrideUserInterfaceStyle = .dark
        }
        setupMiddleButton()
//        self.tabBar.isTranslucent=true
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.tabBar.frame
////        blurView.layer.masksToBounds=true
////        self.view.addSubview(blurEffectView)
//        self.tabBar.addSubview(blurEffectView)
    }
    
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        /*
        var middleBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(.white, for: .normal)
            button.setTitle("More", for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

            let diamond = UIView(frame: button.bounds)
            diamond.translatesAutoresizingMaskIntoConstraints = false
            diamond.isUserInteractionEnabled = false // button will handle touches
            // Handle it gracefully without force unwrapping
            button.insertSubview(diamond, belowSubview: button.titleLabel!)
            diamond.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
            diamond.backgroundColor = .red
            diamond.layer.cornerRadius = 10
            diamond.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            diamond.widthAnchor.constraint(equalTo: diamond.heightAnchor).isActive = true
            diamond.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            diamond.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            return button
        }()
        */
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-30, y: -25, width: 60, height: 60))
//        middleBtn.applyGradient(colors: [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 0.3994577628).cgColor,#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.3918532806).cgColor])
        
        
        middleBtn.setImage( UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .black)), for: .normal)
        
        middleBtn.layer.cornerRadius = middleBtn.layer.bounds.width/2.0
        middleBtn.backgroundColor = .clear
        middleBtn.tintColor = UIColor.white
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        
        let blurView = UIImageView(frame: middleBtn.frame)
        blurView.contentMode = .scaleToFill
        blurView.image = UIImage(named: "financeButtonBG")!
        blurView.layer.masksToBounds=true
        blurView.layer.cornerRadius=blurView.frame.width/2.0
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
        blurView.sendSubviewToBack(blurEffectView)
        self.tabBar.addSubview(blurView)
        
        self.tabBar.bringSubviewToFront(middleBtn)
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
