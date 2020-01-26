//
//  Map.swift
//  miniprojetios
//
//  Created by maryem on 4/24/19.
//  Copyright © 2019 maryem. All rights reserved.
//

import UIKit
import Mapbox
class Map: UIViewController , MGLMapViewDelegate {

    @IBOutlet weak var b: UIButton!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var latitudecab : String?
    var longitudecab : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("cabinet ")
        print(self.latitudecab)
        print(self.longitudecab)
       // b.isHidden == false ;
       // b.frame.origin = CGPoint(x: 100, y:500)
        let mapView = MGLMapView(frame: view.bounds)
      //  mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407), zoomLevel: 12, animated: false)
        view.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407)
        hello.title = "Cabinet"
        hello.subtitle = "Welcome to Cabinet docteur"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(hello)
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
   
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
