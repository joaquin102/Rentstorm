//
//  SearchViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/14/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class RatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var INCOMING_RESERVATIONS_SECTION = 0;
    var NEARBY_RATES_SECTION = 1;
    var SEARCH_SECTION = 2;
    
    //PROPERTIES
    var nearbyRates:[Rate] = [];
    
    //Location
    var locationManager:CLLocationManager!

    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet var viewActivityContainer: UIView!
    @IBOutlet weak var viewActivityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialization()
        UIConfiguration()
        serverData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Initialization -
    
    func initialization() {
        
        //TableView
        
        
        //Location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func UIConfiguration() {
        
        viewActivityIndicator.startAnimating();
        
        //TableView
        tableView.tableFooterView = UIView()
        tableView.backgroundView = viewActivityContainer;
        
        //Search Box
        self.viewSearchContainer.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.viewSearchContainer.layer.shadowRadius = 0.5;
        self.viewSearchContainer.layer.shadowOpacity = 0.8;
        self.viewSearchContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
    //MARK: - ServerData -
    
    func serverData() {
        
        ServerModel.ratesNearby { (rates) in
            
            self.nearbyRates = rates;
            self.tableView.reloadSections(IndexSet.init(integer: self.NEARBY_RATES_SECTION), with: UITableViewRowAnimation.fade)
            
            self.viewActivityIndicator.stopAnimating();
        }
        
    }
    
    
    //MARK: - TableView Datasource|Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == INCOMING_RESERVATIONS_SECTION {
            
            return 0;
        }
        
        if section == NEARBY_RATES_SECTION {
            
            return nearbyRates.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == INCOMING_RESERVATIONS_SECTION {
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "INCOMING RESERVATIONS");
        }
        
        if section == NEARBY_RATES_SECTION {
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "NEAR YOU");
        }
        
        return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "RESULTS");
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == INCOMING_RESERVATIONS_SECTION {
            
            return 0.0
        }
        
        if section == NEARBY_RATES_SECTION {
            
            if nearbyRates.count > 0 {
                
                return 50.0;
            }
            
            return 0.0;
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == INCOMING_RESERVATIONS_SECTION {
            
            return 0;
        }
        
        if indexPath.section == NEARBY_RATES_SECTION {
            
            return 360.0;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == INCOMING_RESERVATIONS_SECTION {
            
            return UITableViewCell();
        }
        
        if indexPath.section == NEARBY_RATES_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath) as! RateTableViewCell;
            
            //Assign
            cell.rate = nearbyRates[indexPath.row];
            
            //Load
            cell.loadInformation();
            
            //Return
            return cell;
        }
        
        return UITableViewCell();
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
