//
//  StationDetailViewController.swift
//  OpenCharge
//
//  Created by Kiril Maneichyk on 17/01/2021.
//

import UIKit
import MapKit

class StationDetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var station: Station? = nil
    let locationMaganer = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var operatorInfo: UILabel!
    @IBOutlet weak var usageInfo: UILabel!
    @IBOutlet weak var generalInfo: UILabel!
    @IBOutlet weak var addressInfo: UILabel!
    @IBOutlet weak var callBtn: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let station = station else {
            return
        }
        self.title = station.addressInfo.title
        
        
        if let operatorInfo = station.operatorInfo {
            var operatorInfoText = operatorInfo.title
            if let operatorEmail = operatorInfo.contactEmail {
                operatorInfoText.append(", email: \(operatorEmail)")
            }
            operatorInfoText.append(".")
            self.operatorInfo.text = operatorInfoText
        } else {
            self.operatorInfo.isHidden = true
        }
        
        
        var addressInfo = station.addressInfo.addressLine1
        if let addressLine2 = station.addressInfo.addressLine2 {
            addressInfo.append(", \(addressLine2)")
        }
        
        if station.addressInfo.contactTelephone1 != nil {
            self.callBtn.isEnabled = true
        }
        self.addressInfo.text = addressInfo
        
        if let usageInfo = station.usageType {
            self.usageInfo.text = usageInfo.title
        } else {
            self.usageInfo.isHidden = true
        }
        
        if let generalComment = station.generalComments {
            self.generalInfo.text = generalComment
        } else {
            self.generalInfo.isHidden = true
        }
        self.reload()
    }
    
    override func viewDidLoad() {
        guard let station = self.station else {
            return
        }
        let stationPoint = MKPointAnnotation()
        stationPoint.title = station.addressInfo.title
        let stationLocation = CLLocationCoordinate2D(latitude: station.addressInfo.latitude, longitude: station.addressInfo.longitude)
        stationPoint.coordinate = stationLocation
        map.addAnnotation(stationPoint)
        let rect = MKMapRect(x: userLocation.latitude, y: userLocation.longitude, width: 0, height: 0).union(MKMapRect(x: stationLocation.latitude, y: stationLocation.longitude, width: 0, height: 0))
        map.setVisibleMapRect(rect, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func reload() {
        locationMaganer.requestWhenInUseAuthorization()
        locationMaganer.delegate = self
        locationMaganer.desiredAccuracy = kCLLocationAccuracyBest
        locationMaganer.requestLocation()
    }
    
    func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Fail", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        alert.addAction(UIAlertAction(title: "Try again", style: .default) { _ in self.reload()})
        self.present(alert, animated: true)
    }
    
    func showWaring(_ warning: String) {
        let alert = UIAlertController(title: "Warning", message: warning, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            self.showWaring("No last location. Showing default location")
            self.userLocation = CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.017532)
            return
        }
        self.userLocation = lastLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            self.showErrorMessage("Location cannot be fetched")
            return
        }
        switch error.code {
        case .denied:
            self.userLocation = CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.017532)
        default:
            self.showErrorMessage("Location cannot be fetched")
        }
    }
    
    @IBAction func call(_ sender: Any) {
        guard let station = station else {return}
        guard let phone = station.addressInfo.contactTelephone1 else {return}
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            let alert = UIAlertController(title: ("Call " + phone + "?"), message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    }))

                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
        }
    }
}
