//
//  journalLocationPickerViewController.swift
//  Folio
//
//  Created by Kshitiz Sharma on 31/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//class newctatreme: Codable{
//    var locationAnnotations = MKPointAnnotation()
//}

class journalLocationPickerViewController: UIViewController {
    
    var delegate: addCardInJournalProtocol?
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var locationAnnotations = [CodableMKPointAnnotation]()
    var myIndex = IndexPath(row: 0, section: 0)
    var currentLocationAnnotation: CodableMKPointAnnotation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
        if locationAnnotations.count>0{
            mapView.addAnnotation(locationAnnotations[0])
            if locationAnnotations.count>1{
                mapView.addAnnotation(locationAnnotations[1])
            }
        }
        
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.revealRegionDetailsWithLongPressOnMap(sender:))))
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
    }
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            print("completion handle of cancel tap")
        }
    }
    @IBAction func handleDone(_ sender: Any) {
        delegate!.setJournalLocation(at: myIndex, to: locationAnnotations)
        self.dismiss(animated: true) {
            print("completion handle of done tap")
        }
    }
    @IBAction func handleInstantLocationTap(_ sender: Any) {
        if locationAnnotations.count>0{
            mapView.setCenter(locationAnnotations[0].coordinate, animated: true)
        }
    }
    @IBAction func handleSelectedLocationTap(_ sender: Any) {
        if locationAnnotations.count>1{
            mapView.setCenter(locationAnnotations[1].coordinate, animated: true)
        }
    }
    @IBAction func handleCurrentLocationTap(_ sender: Any) {
        if let coor = currentLocationAnnotation{
            print("found cur loc")
            mapView.setCenter(coor.coordinate, animated: true)
        }
    }
    //TODO: instant location not named properly when reopening map
    
    @objc func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        mapView.setCenter(locationCoordinate, animated: true)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = CodableMKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "selected location"
        //        annotation.subtitle = "current location"
//        mapView.addAnnotation(annotation)
//        print("old size = \(locationAnnotations.count)")
        //        locationAnnotations.append(annotation)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        if locationAnnotations.count==1{
            print("added selected location annotation")
            mapView.addAnnotation(annotation)
            locationAnnotations.append(annotation)
        }else if locationAnnotations.count==2{
            print("added selected location annotation")
            mapView.removeAnnotation(locationAnnotations[1])
            mapView.addAnnotation(annotation)
            locationAnnotations[1]=annotation
        }else{
            print("WARNING: SOMETHING IS WRONG IN ADDING LOCATIONS")
        }
        
    }
    
}
extension journalLocationPickerViewController: CLLocationManagerDelegate,MKMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let curanot = CodableMKPointAnnotation()
        curanot.coordinate = locValue
        curanot.subtitle = "current location"
        if currentLocationAnnotation==nil{
            currentLocationAnnotation=curanot
            mapView.addAnnotation(curanot)
        }else{
            mapView.removeAnnotation(curanot)
            currentLocationAnnotation=curanot
            mapView.addAnnotation(curanot)
        }

        let annotation = CodableMKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "instant location"
        if locationAnnotations.count==0{
            print("added instant location annotation")
            mapView.addAnnotation(annotation)
            locationAnnotations.append(annotation)
        }
        
        //centerMap(locValue)
    }
}
