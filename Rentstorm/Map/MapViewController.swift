//
//  MapViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/18/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewInfoContainer: UIView!
    @IBOutlet weak var lbl_eta: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_transport: UILabel!
    
    @IBOutlet weak var viewActivityContainer: UIView!
    @IBOutlet weak var viewActivityIndicator: NVActivityIndicatorView!
    
    var rateSelected:Rate!
    var currentRoute: MKRoute?;
    var currentLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization();
        UIConfiguration()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated);
        
        mapView = nil;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialization() {
        
        //Map
        mapConfiguration()

    }
    
    func mapConfiguration() {
        
        //Init
        mapView.showsScale = true;
        mapView.showsPointsOfInterest = true;
        mapView.showsUserLocation = true;
        
        //Current location
        LocationModel.sharedInstance.currentLocation { (currentLocation, error) in
            
            if error == nil {
                
                let sourcePlacemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!));
                let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2DMake((self.rateSelected.branchLocation?.coordinate.latitude)!, (self.rateSelected.branchLocation?.coordinate.longitude)!));
                
                let sourceItem = MKMapItem(placemark: sourcePlacemark);
                let destinationItem = MKMapItem(placemark: destinationPlacemark);
                
                let directionRequest = MKDirectionsRequest();
                directionRequest.source = sourceItem;
                directionRequest.destination = destinationItem;
                directionRequest.transportType = .automobile; //default
                
                //Calculate directions
                let directions = MKDirections(request: directionRequest);
                directions.calculate(completionHandler: { (response, error) in
                    
                    if error == nil {
                        
                        //Route
                        let route = response?.routes[0];
                        self.mapView.add((route?.polyline)!, level: .aboveRoads);
                        
                        //Rect
                        let rectangle = route?.polyline.boundingMapRect;
                        self.mapView.setVisibleMapRect(rectangle!, edgePadding: UIEdgeInsetsMake(70, 70, 70, 70), animated: true);
                        
                        //Annotation
                        let destinationAnnotation = MKPointAnnotation()
                        destinationAnnotation.coordinate = destinationPlacemark.coordinate
                        self.mapView.addAnnotation(destinationAnnotation)
                        
                        //Information
                        self.routeInformation(route: route!);
                        
                        //Keep route and location
                        self.currentRoute = route;
                        self.currentLocation = currentLocation;
                        
                    }else{
                        
                        print("Error")
                    }
                    
                })
            
            }else{
                
                //Error getting location
                
            }
        }
    }
    
    func UIConfiguration() {
        
        //barButtonItem
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "List"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(self.openStepByStep), for: .touchUpInside);
        
        let rightBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let width = rightBarButton.customView?.widthAnchor.constraint(equalToConstant: 22)
        width?.isActive = true
        let height = rightBarButton.customView?.heightAnchor.constraint(equalToConstant: 22)
        height?.isActive = true
        
        self.customPopViewController();
        
        //Title
        self.title = "Directions";
    }
    
    // MARK: - INFO METHODS
    
    func routeInformation(route:MKRoute) {
        
        //ETA
        self.lbl_eta.text = route.expectedTravelTime.timeToString(style: .abbreviated)
        
        //Distance
        
        self.lbl_distance.text = String(describing: (route.distance * 0.000621371192).roundToDecimal(1)) + "m"; //miles
        
        //Transport
        if route.transportType == .automobile {
            
            self.lbl_transport.text = "Car";
        }
        
        if route.transportType == .transit {
            
            self.lbl_transport.text = "Transit";
        }
        
        if route.transportType == .walking {
            
            self.lbl_transport.text = "Walking";
        }
        
        //Show
        showRouteInformation();
        
    }
    
    // MARK: - UI -
    
    func showActivityIndicator() {
        
        self.viewActivityContainer.alpha = 1;
        self.viewActivityIndicator.startAnimating();
    }
    
    func showRouteInformation() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.viewActivityContainer.alpha = 0
        }
    }
    
    
    // MARK: - MAP KIT DELEGATE
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay);
        renderer.strokeColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
        renderer.lineWidth = 5;
        
        return renderer;
    }
    
    
    // MARK: - SELECTORS -
    
    @objc func openStepByStep() {
        
        if currentRoute != nil {
            
            performSegue(withIdentifier: "directionsVC", sender: self);
        }
    }


     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "directionsVC"{
            
            let directionsVC = segue.destination as! DirectionsTableViewController;
            directionsVC.currentLocation = currentLocation;
            directionsVC.rateSelected = rateSelected;
            directionsVC.dataSource = currentRoute?.steps
        }
     }

    
}

extension MKPointAnnotation {
    class func bluePinColor() -> UIColor {
        return UIColor.blue
    }
}

extension Double {
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func timeToString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
}

