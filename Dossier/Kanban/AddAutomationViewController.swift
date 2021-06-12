//
//  AddAutomationViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 16/12/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
protocol addAutomationVCProtocol {
    func editCommand(to newComand: Command)
    func deleteCommand(to newComand: Command)
    func doEditCommandSegue(using tvc: commandTableViewCell)
}
class AddAutomationViewController: UIViewController {
    var boardFileName = "empty.json"
    var kanban = Kanban()
    var isAppearingFirstTime = true
//    var backgroundImage: UIImage?
    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.addBlurEffect(with: .systemUltraThinMaterialDark)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource=self
            tableView.delegate=self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let bgImage = backgroundImage{
//            self.backgroundImageView.image=bgImage
//        }
    }
    @IBAction func toggleEditting(_ sender: Any) {
        self.tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @IBAction func addCommand(_ sender: UIBarButtonItem) {
        //TODO: first do segue then add command if correct
        kanban.commands.append(Command())
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: kanban.commands.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: kanban.commands.count-1, section: 0), at: .middle, animated: true)
//        self.shouldPerformSegue(withIdentifier: "commandDetailSegue", sender: tableView.cellForRow(at: IndexPath(row: kanban.commands.count-1, section: 0)))
//        tableView.selectRow(at: IndexPath(row: kanban.commands.count-1, section: 0), animated: true, scrollPosition: .middle)
    }
    override func viewWillAppear(_ animated: Bool) {
        //setting darkmode/lightmode/automode
        let interfaceStyle = UserDefaults.standard.integer(forKey: "prefs_is_dark_mode_on")
        if interfaceStyle==0{
            overrideUserInterfaceStyle = .unspecified
        }else if interfaceStyle==1{
            overrideUserInterfaceStyle = .light
        }else if interfaceStyle==2{
            overrideUserInterfaceStyle = .dark
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        print("running viewwilapap")
        if isAppearingFirstTime{
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(boardFileName){
                //            print("trying to extract contents of kanbanData")
                if let jsonData = try? Data(contentsOf: url){
                    //                pageList = pageInfo(json: jsonData)
                    if let x = Kanban(json: jsonData){
                        kanban = x
                    }else{
                        print("WARNING: COULDN'T UNWRAP JSON DATA TO FIND kanbanData")
                    }
                }
                tableView.reloadData()
            }
            if let wallpath = self.kanban.wallpaperPath{
                DispatchQueue.global(qos: .background).async {
                    print("got wall path")
                    if let url = try? FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true
                    ).appendingPathComponent(wallpath){
                        if let jsonData = try? Data(contentsOf: url){
                            if let extract = imageData(json: jsonData){
                                let x=extract.data
                                if let image = UIImage(data: x){
                                    print("got the background image")
                                    DispatchQueue.main.async {
                                        //                                    self.previewImageView.image = image
                                        self.backgroundImageView.image = image
                                    }
                                }
                            }else{
                                print("couldnt get json from URL")
                            }
                        }
                    }
                }
            }
            isAppearingFirstTime=false
        }else{
            tableView.reloadData()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    func save(){
        if let json = kanban.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(boardFileName){
                do {
                    try json.write(to: url)
                    print ("saved successfully")
                } catch let error {
                    print ("couldn't save \(error)")
                }
            }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditCommandViewController, let tableCell = sender as? commandTableViewCell{
            vc.delegate=self
            vc.command=tableCell.command
            vc.backgroundImage = self.backgroundImageView.image
            vc.kanbanFileName=self.boardFileName
        }
    }

}
extension AddAutomationViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanban.commands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commandTVCIdentifier") as! commandTableViewCell
//        cell.commandNameTextField.text="23453"
        cell.automDelegate=self
        cell.command = self.kanban.commands[indexPath.row]
        cell.updateLook()
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let data = self.kanban.commands.remove(at: sourceIndexPath.row)
        self.kanban.commands.insert(data, at: destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
            kanban.commands.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
extension AddAutomationViewController: addAutomationVCProtocol{
    func doEditCommandSegue(using tvc: commandTableViewCell) {
        self.performSegue(withIdentifier: "newCommandDetailSegue", sender: tvc)
    }
    
    func deleteCommand(to newComand: Command) {
        for ind in kanban.commands.indices{
            if kanban.commands[ind].uniqueIdentifier == newComand.uniqueIdentifier{
                kanban.commands.remove(at: ind)
//                tableView.reloadData()
                break
            }
        }
        
    }
    
    func editCommand(to newComand: Command) {
        print("editting command with title: \(newComand.name)")
        for ind in kanban.commands.indices{
            if kanban.commands[ind].uniqueIdentifier == newComand.uniqueIdentifier{
                print("found match with command with original title: \(kanban.commands[ind].name)")
                kanban.commands[ind] = newComand
//                tableView.reloadData()
                break
            }
        }
    }
    
}

class commandTableViewCell: UITableViewCell{
    var command = Command()
    var automDelegate: addAutomationVCProtocol?
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var blurView: UIView!{
        didSet{
            blurView.layer.cornerRadius = 10
            blurView.layer.masksToBounds=false
            blurView.backgroundColor = .clear
            
            blurView.addBlurEffect(with: .systemThinMaterial)
            
            blurView.isUserInteractionEnabled=true
            blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doEditSegue)))
        }
    }
    @objc func doEditSegue(){
        print("Edit Segue")
        automDelegate?.doEditCommandSegue(using: self)
    }
    @IBOutlet weak var categoryImageView: UIImageView!{
        didSet{
            categoryImageView.layer.cornerRadius = 8
            //Draw shaddow for layer
            categoryImageView.layer.masksToBounds=false
            categoryImageView.layer.shadowColor = UIColor.gray.cgColor
            categoryImageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            categoryImageView.layer.shadowRadius = 10.0
            categoryImageView.layer.shadowOpacity = 0.25
//            let smallConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .small)
            let iconColor = [#colorLiteral(red: 0.886832118, green: 0.9455494285, blue: 0.9998298287, alpha: 1), #colorLiteral(red: 0.9906743169, green: 0.8905956149, blue: 0.8889676332, alpha: 1), #colorLiteral(red: 0.755782187, green: 1, blue: 0.8466194272, alpha: 1), #colorLiteral(red: 0.9186416268, green: 0.7921586633, blue: 0.9477668405, alpha: 1)].randomElement()
            self.categoryImageView.backgroundColor = iconColor
            self.categoryImageView.tintColor = iconColor?.darker(by: 50)
            
            self.categoryImageView.isUserInteractionEnabled=true
            self.categoryImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleEnabled)))
            
        }
    }
    
    @objc func toggleEnabled(){
        print("Toggle Enabled")
        command.enabled = !command.enabled
        updateLook()
    }
    @IBOutlet weak var commandNameTextField: UITextField!
    @IBOutlet weak var subTitleTextLabel: UILabel!
    
    func updateLook(){
        self.commandNameTextField.text = command.name
        let symbolConfig = UIImage.SymbolConfiguration(scale: .medium)
        if command.enabled{
            categoryImageView.image = UIImage(systemName: "lock.open.fill", withConfiguration: symbolConfig)
        }else{
            categoryImageView.image = UIImage(systemName: "lock.slash.fill", withConfiguration: symbolConfig)
        }
        automDelegate?.editCommand(to: command)
    }
}
