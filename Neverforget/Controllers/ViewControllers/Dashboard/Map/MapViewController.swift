//
//  MapViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/21/22.
//

import UIKit
import MapKit
import CoreLocation


protocol HandleMapSearch {
    //bs post the dialogue bubble of the pin.
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    private var resultSearchController: UISearchController?
    private var selectedPin: MKPlacemark?
    private let locationManager = CLLocationManager()
    
    //a handle to the search screen
    var handleMapSearchDelegate:HandleMapSearch? = nil
    @IBOutlet var map: MKMapView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupSearchController()
        //map.delegate = self
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func setupSearchController() {
        // Instantiate the LocationSearchTableViewController from the storyboard.
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        
        // Create a UISearchController with the LocationSearchTableViewController as the search results controller.
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        
        // Set the search results updater to the LocationSearchTableViewController.
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // Get the search bar from the search controller and customize it.
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.searchTextField.font = UIFont(name: "Deysia Brush", size: 15)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search for stores:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        
        // Set the search controller as the navigation item's search controller.
        navigationItem.searchController = resultSearchController
        
        // Configure the search controller to show the navigation bar while searching and obscure the background.
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        
        // Set the map view and handleMapSearchDelegate properties of the LocationSearchTableViewController.
        locationSearchTable.mapView = map
        locationSearchTable.handleMapSearchDelegate = self
    }
}

//implements the CLLocationManagerDelegate protocol to handle location updates
extension MapViewController: CLLocationManagerDelegate {
    
    // This method is called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            // Define the amount of map area to display around the user's location
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            // Define the region of the map to display based on the user's location and the span
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            map.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: HandleMapSearch {
    // This function is called when a location is selected from the search results
    func dropPinZoomIn(placemark: MKPlacemark) {
        // Set the selectedPin property to the placemark that was passed in
        selectedPin = placemark
        
        // Remove any existing annotations from the map
        map.removeAnnotations(map.annotations)
        
        // Create a new annotation and set its coordinate and title
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        // If the placemark has a locality, sub-thoroughfare, thoroughfare, and administrative area,
        // set the annotation's subtitle to include all of those elements
        if let city = placemark.locality,
           let number = placemark.subThoroughfare,
           let street = placemark.thoroughfare,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(number) \(street),\(city), \(state)"
        }
        
        // Add the new annotation to the map
        map.addAnnotation(annotation)
        
        // Set the map's region to show the selected location
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        map.setRegion(region, animated: true)
        
        // Stop updating the user's location
        locationManager.stopUpdatingLocation()
    }
}
