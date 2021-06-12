//
//  doneToDismissTextView.swift
//  Folio
//
//  Created by Kshitiz Sharma on 05/06/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import UIKit
extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

/* how to use
 class ViewController: UIViewController {
     
     @IBOutlet weak var myTextView: UITextView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         // 1
         self.myTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
     }
     
     // 2
     @objc func tapDone(sender: Any) {
         self.view.endEditing(true)
     }
 }
 */
