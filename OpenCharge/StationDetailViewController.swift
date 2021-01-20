//
//  StationDetailViewController.swift
//  OpenCharge
//
//  Created by Kiril Maneichyk on 17/01/2021.
//

import UIKit
import MapKit

class StationDetailViewController: UIViewController {
    var station: Station? = nil
    let locationMaganer = CLLocationManager()
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
