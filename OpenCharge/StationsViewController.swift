//
//  StationsViewController.swift
//  OpenCharge
//
//  Created by Kiril Maneichyk on 17/01/2021.
//

import UIKit
import Alamofire

class StationsViewController:  UITableViewController {
    
    var loadedStations: [Station] = []
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadedStations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationViewCell
         
        cell.stationNameLable.text = self.loadedStations[indexPath.row].addressInfo.title
        let distance = self.loadedStations[indexPath.row].addressInfo.distance
        
         if distance >= 1 {
             cell.stationDistanceLable.text = "\(distance) km"
         } else {
             cell.stationDistanceLable.text = "\(Int(distance*1000)) m"
         }
         
         return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowStation", sender: nil)
        
    }
    
    @IBAction func reload() {
        AF.request("https://api.openchargemap.io/v3/poi/?output=json&opendata=true&latitude=52.223120&longitude=20.939920").responseJSON { response in
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
}
