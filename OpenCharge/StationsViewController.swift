//
//  StationsViewController.swift
//  OpenCharge
//
//  Created by Kiril Maneichyk on 17/01/2021.
//

import UIKit

class StationViewCell: UITableViewCell {
    @IBOutlet weak var stationDistanceLable: UILabel!
    @IBOutlet weak var stationNameLable: UILabel!
}

class StationsViewController:  UITableViewController {
    let stations: [Station] = [
        Station(name: "Orange", distance: 25.5),
        Station(name: "BP", distance: 12.2),
        Station(name: "Orlen", distance: 5.1),
        Station(name: "CircleK", distance: 15.5),
        Station(name: "Nearest", distance: 0.5)
    ]
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationViewCell
        
        cell.stationNameLable.text = stations[indexPath.row].name
        let distance = stations[indexPath.row].distance
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStation" {
            let viewController = segue.destination as! StationDetailViewController
            if let index = tableView.indexPathForSelectedRow {
                viewController.station = stations[index.row]
            }
        }
    }
}
