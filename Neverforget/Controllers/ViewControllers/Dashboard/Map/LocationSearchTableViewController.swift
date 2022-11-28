//
//  LocationSearchTableViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/22/22.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    //bs post the dialogue bubble of the pin.
    func dropPinZoomIn(placemark:MKPlacemark)
}

class LocationSearchTableViewController: UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    //a handle to the map from the previous screen
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//Protocol to update search results based on user's search bar input
extension LocationSearchTableViewController : UISearchResultsUpdating {
    //Set up the API. call delegate that responds to search bar text entry
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        //performs the actual search on the request object.
        let search = MKLocalSearch(request: request)
        // responses:an array of mapItems.
        search.start { [self] response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
            //after this, data come back from API
        }
    }
}
//Set up the Table View Data Source
extension LocationSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        //When a search result row is selected, you find the appropriate placemark based on the row number.
        let selectedItem = matchingItems[indexPath.row].placemark
        print(selectedItem)
        cell.textLabel?.text = selectedItem.name
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        cell.detailTextLabel?.text = address
        return cell
    }
}

extension LocationSearchTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        //Finally, close the search results modal so the user can see the map.
        self.dismiss(animated: true, completion: nil)
    }
}
