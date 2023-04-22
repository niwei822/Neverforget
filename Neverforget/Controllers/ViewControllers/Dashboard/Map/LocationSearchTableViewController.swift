//
//  LocationSearchTableViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/22/22.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    
    // Array to store the search results
    var matchingItems: [MKMapItem] = []
    
    // Map view property used to display search results
    weak var mapView: MKMapView?
    
    // Delegate property to handle map search events
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Protocol to update search results based on user's search bar input
extension LocationSearchTableViewController: UISearchResultsUpdating {
    
    // This method is called when the search bar text changes
    func updateSearchResults(for searchController: UISearchController) {
        
        // Get the mapView and searchBarText from the search controller
        guard let mapView = mapView, // Map view to search in
              let searchBarText = searchController.searchBar.text else { return } // Search bar text entered by user
        
        // Create a new local search request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText // Set the search query to the user's text input
        request.region = mapView.region // Set the region to search within to the current mapView region
        
        // Create a new local search with the request
        let search = MKLocalSearch(request: request)
        
        // Start the search and wait for a response
        search.start { [weak self] response, error in
            
            // Ensure that self is still in memory and that there are no errors
            guard let self = self, error == nil,
                  let response = response else { return }
            
            // Set the matchingItems property to the mapItems in the search response
            self.matchingItems = response.mapItems
            
            // Reload the table view to show the updated search results
            self.tableView.reloadData()
        }
    }
}

// Set up the Table View Data Source
extension LocationSearchTableViewController {
    
    // Return the number of rows in the table view section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    // Configure and return a cell for the specified index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! // Dequeue a reusable cell with the identifier "cell"
        let selectedItem = matchingItems[indexPath.row].placemark // Get the selected placemark
        
        // Set the cell's text label to the placemark's name
        cell.textLabel?.text = selectedItem.name
        
        // Create an address string using the placemark's address components
        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
        
        // Set the cell's detail text label to the address string
        cell.detailTextLabel?.text = address
        
        return cell
    }
}

extension LocationSearchTableViewController {
    
    // Handle a row being selected in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark // Get the selected placemark
        
        // Call the handleMapSearchDelegate's dropPinZoomIn method with the selected placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        
        // Dismiss the search results table view
        self.dismiss(animated: true, completion: nil)
    }
}

