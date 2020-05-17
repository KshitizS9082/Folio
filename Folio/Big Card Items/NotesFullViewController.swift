//
//  NotesFullViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 12/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import SPFakeBar
import SPStorkController

class NotesFullViewController: UIViewController, SPStorkControllerDelegate {
    //    var delegate: UpdateCardProtocol?
    var viewLinkedTo: cardView?
    var card: Card = Card()
    let navBar = SPFakeBarView(style: .stork)
    
    var notesTextView = UnderlinedTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = noteColour
        configureNavBar()
        configureNotesTextView()
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc private func editButtonPressed(){
        isEditing = !isEditing
        print("changed isEditing to \(isEditing)")
        card.notes = notesTextView.text
        //        delegate?.nowUpdateCard(newCard: card, for: viewLinkedTo!)
        viewLinkedTo?.card=card
        viewDidLoad()
        viewLinkedTo?.layoutSubviews()
    }
    private func configureNavBar(){
        self.navBar.titleLabel.text = "Notes"
        if(isEditing){
            self.navBar.leftButton.setTitle("Done", for: .normal)
        }
        else {
            self.navBar.leftButton.setTitle("Edit", for: .normal)
        }
        self.navBar.leftButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        if(view.subviews.contains(self.navBar)==false){
            self.view.addSubview(self.navBar)
        }
    }
    private func configureNotesTextView(){
        if(view.subviews.contains(notesTextView)==false){
            view.addSubview(notesTextView)
        }
        notesTextView.font = UIFont.preferredFont(forTextStyle: .body)
        notesTextView.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: notesTextView.font!)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        [
            notesTextView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            notesTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notesTextView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
            notesTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ].forEach { (constraints) in
                constraints.isActive = true
        }
        //set offset from corners of notes
        notesTextView.textContainerInset = UIEdgeInsets(top: cornerRadius/2, left: cornerRadius/2, bottom: cornerRadius/2, right: cornerRadius/2)
        notesTextView.layer.cornerRadius = cornerRadius/2
        notesTextView.autocorrectionType = UITextAutocorrectionType.no
        notesTextView.backgroundColor = noteColour
        notesTextView.isEditable = isEditing
        notesTextView.text = card.notes
    }
    func didDismissStorkByTap() {
        print("dismissed by tap")
        card.notes = notesTextView.text
        viewLinkedTo?.card=card
        viewLinkedTo?.layoutSubviews()
    }
    func didDismissStorkBySwipe() {
        print("dismissed by swipe")
        didDismissStorkByTap()
    }
    @objc func keyboardWillShow( note:NSNotification ){
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            notesTextView.textContainerInset = insets
        }
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

extension NotesFullViewController{
    var cornerRadius: CGFloat {
        return view.bounds.size.height * 0.03
    }
    var noteColour: UIColor{
        return #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
    }
}
