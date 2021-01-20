//
//  StationsViewController.swift
//  OpenCharge
//
//  Created by Kiril Maneichyk on 17/01/2021.
//

import UIKit
import MapKit
import Alamofire

class StationsViewController:  UITableViewController, CLLocationManagerDelegate {
    
    var loadedStations: [Station] = []
    let locationMaganer = CLLocationManager()
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadedStations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationViewCell
        
        let station = self.loadedStations[indexPath.row]
         
        cell.stationNameLable.text = station.addressInfo.title
        let distance = station.addressInfo.distance
        
         if distance >= 1 {
             cell.stationDistanceLable.text = "\(distance) km"
         } else {
             cell.stationDistanceLable.text = "\(Int(distance*1000)) m"
         }
        
        if let price = station.usageCost {
            cell.priceLabel.text = price
        } else {
            cell.priceLabel.text = "There is no price info"
        }
        
         
         return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowStation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowStation" else {
            return
        }
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        let detailsViewController = segue.destination as! StationDetailViewController
        detailsViewController.station = loadedStations[indexPath.row]
    }
    
    @IBAction func reload() {
        locationMaganer.requestWhenInUseAuthorization()
        locationMaganer.delegate = self
        locationMaganer.requestLocation()
        locationMaganer.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func reloadStations(coordinate: CLLocationCoordinate2D) {
        AF.request("https://api.openchargemap.io/v3/poi/?output=json&opendata=true&latitude=\(coordinate.latitude)&longitude=\(coordinate.longitude)").responseJSON { response in
            if let data  = response.data {
                do {
                    let stations = try JSONDecoder().decode([Station].self, from: data)
                    self.loadedStations = stations.sorted { (s1, s2) -> Bool in s1.addressInfo.distance < s2.addressInfo.distance }
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func showErrorMessage(_ error: Error) {
        let alert = UIAlertController(title: "Fail", message: error.localizedDescription, preferredStyle: .alert)
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
            self.showWaring("Test")
            return
        }
        self.reloadStations(coordinate: lastLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showErrorMessage(error)
    }
}
