//
//  drawingBoardViewController.swift
//  card2
//
//  Created by Kshitiz Sharma on 08/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import SPFakeBar
import SPStorkController
import PencilKit

//TODO: Hide toolkit pallete when user is not editing

class drawingCardFullViewController: UIViewController, SPStorkControllerDelegate, PKCanvasViewDelegate {
//    var delegate: UpdateCardProtocol?
    var viewLinkedTo: cardView?
    var card: Card = Card()
//    let navBar = SPFakeBarView(style: .stork)
    var myCanvasView = PKCanvasView(frame: .zero)
    var toolPicker : PKToolPicker? = nil
    @IBOutlet weak var navBar: UINavigationBar!
    
    private func setDrawingCanvaa(){
        self.view.backgroundColor = canvasBackgroundColoer
        myCanvasView.backgroundColor = canvasBackgroundColoer
        myCanvasView.delegate = self
//        canvasView.bac
        if(view.subviews.contains(myCanvasView)==false){
            view.addSubview(myCanvasView)
        }
        myCanvasView.translatesAutoresizingMaskIntoConstraints = false
        myCanvasView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        myCanvasView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        myCanvasView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        myCanvasView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
//        myCanvasView.drawing=card.savedpkDrawing
        //MARK: PKData attempt
        do {
            let d = try PKDrawing.init(data: card.savedPKData)
            myCanvasView.drawing = d
            print("succesfully did set pkd")
        } catch  {
            print("error trying to initilise pkd from data")
        }
        guard
            let window = myCanvasView.window,
           let toolPicker = PKToolPicker.shared(for: window) else { return }
        toolPicker.setVisible(true, forFirstResponder: myCanvasView)
        toolPicker.addObserver(myCanvasView)
        myCanvasView.contentSize = self.view.bounds.size
        myCanvasView.bouncesZoom = true
        myCanvasView.isScrollEnabled = true
        myCanvasView.minimumZoomScale = minimumZoomScale
        myCanvasView.maximumZoomScale = maximumZoomScale
        myCanvasView.becomeFirstResponder()
        
    }
//    private func configureNavBar(){
//        self.navBar.titleLabel.text = "Drawing"
//        if(isEditing){
//            self.navBar.leftButton.setTitle("Done", for: .normal)
//        }
//        else {
//            self.navBar.leftButton.setTitle("Edit", for: .normal)
//        }
//        self.navBar.leftButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
//        if(view.subviews.contains(self.navBar)==false){
//            self.view.addSubview(self.navBar)
//        }
//    }
    private func reconfigureAll(){
//        if(isEditing){
//            self.navBar.left.setTitle("Done", for: .normal)
//        }
//        else {
//            self.navBar.leftButton.setTitle("Edit", for: .normal)
//        }
        if isEditing{
            myCanvasView.becomeFirstResponder()
        }else{
            myCanvasView.resignFirstResponder()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavBar()
    }
    override func viewDidLayoutSubviews() {
//        reconfigureAll()
//        configureNavBar()
        setDrawingCanvaa()
    }

    @objc private func editButtonPressed(){
        togglePicker()
        //TODO: works only for disallowing fingerdrawing, and not apple pecil
//        myCanvasView.isUserInteractionEnabled = !myCanvasView.isUserInteractionEnabled
        isEditing = !isEditing
        myCanvasView.allowsFingerDrawing = isEditing
//        myCanvasView.allowsFingerDrawing = !myCanvasView.allowsFingerDrawing
//        viewDidLoad()
//        viewDidLayoutSubviews()
        reconfigureAll()
    }
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
//        card.savedpkDrawing = canvasView.drawing
        //MARK: PKData attempt
        card.savedPKData = canvasView.drawing.dataRepresentation()
        print("did initilise data from pkd")
           
    }
//    func didDismissStorkByTap() {
//        print("dismissed by tap")
////        delegate?.nowUpdateCard(newCard: card, for: viewLinkedTo!)
//        viewLinkedTo?.card=card
//        viewLinkedTo?.layoutSubviews()
//    }
//    func didDismissStorkBySwipe() {
//        print("dismissed by swipe")
//        didDismissStorkByTap()
//    }
    @IBAction func handleCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleDone(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.viewLinkedTo?.card=self.card
            self.viewLinkedTo?.layoutSubviews()
        }
    }
    
    @objc func togglePicker() {
        if myCanvasView.isFirstResponder{
            myCanvasView.resignFirstResponder()
        }else{
            myCanvasView.becomeFirstResponder()
        }
    }
}
extension drawingCardFullViewController{
    var canvasBackgroundColoer: UIColor{
        return UIColor(named: "bigCardColor") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    var minimumZoomScale: CGFloat{
        return 1
    }
    var maximumZoomScale: CGFloat{
        return 3
    }
}

