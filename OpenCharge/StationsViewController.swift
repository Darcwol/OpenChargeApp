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
        let distance = Measurement(value: station.addressInfo.distance, unit: UnitLength.miles).converted(to: UnitLength.kilometers).value
        
        if distance >= 1 {
            cell.stationDistanceLable.text = "\(String(format: "%.2f", distance)) km"
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
        locationMaganer.desiredAccuracy = kCLLocationAccuracyBest
        locationMaganer.requestLocation()
    }
    
    func reloadStations(coordinate: CLLocationCoordinate2D) {
        AF.request("https://api.openchargemap.io/v3/poi/?output=json&opendata=true&latitude=\(coordinate.latitude)&longitude=\(coordinate.longitude)").responseJSON { response in
            if let data  = response.data {
                do {
                    let stations = try JSONDecoder().decode([Station].self, from: data)
                    self.loadedStations = stations.sorted { (s1, s2) -> Bool in s1.addressInfo.distance < s2.addressInfo.distance }
                    self.tableView.reloadData()
                } catch {
                    self.showErrorMessage(error.localizedDescription)
                }
            }
        }
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
            self.reloadStations(coordinate: CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.017532))
            return
        }
        self.reloadStations(coordinate: lastLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            self.showErrorMessage("Location cannot be fetched")
            return
        }
        switch error.code {
        case .denied:
            self.reloadStations(coordinate: CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.017532))
        default:
            self.showErrorMessage("Location cannot be fetched")
        }
    }
}
