//
//  WeatherTableViewController.swift
//  WeatherProject
//
//  Created by Maik Rengsberger on 16.07.17.
//  Copyright © 2017 Maik Rengsberger. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class WeatherTableViewController: UITableViewController,UISearchBarDelegate {
    


    @IBOutlet weak var searchBar: UISearchBar!
    var forecastWeather = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        updateWeatherForLocation(location: "Dresden")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty{
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation(location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?,error: Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: {( results: [Weather]?) in
                        if let weatherData = results {
                            self.forecastWeather = weatherData
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecastWeather.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let weatherObject = forecastWeather[indexPath.section]
        cell.textLabel?.text = weatherObject.summary
        let tempMin = convertToCelsius(fahrenheit: Int(weatherObject.temperatureMin))
        let tempMax = convertToCelsius(fahrenheit: Int(weatherObject.temperatureMax))
        cell.detailTextLabel?.text = "Min:\(tempMin) °C Max:\(tempMax) °C"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MMMM YYYY"
        
        return dateFormatter.string(from: date!)
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
