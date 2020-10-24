//
//  KanbanTimelineViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 23/10/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit

class KanbanTimelineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}
extension KanbanTimelineViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell()
        return cell
    }
    
    
}
