//
//  DirectionsTableViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/19/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import MapKit

class DirectionsTableViewController: UITableViewController {

    //PROPERTIES
    var rateSelected:Rate!
    var currentLocation:CLLocation!
    
    //DATASOURCE
    var dataSource:[MKRouteStep]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIConfiguration();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIConfiguration() {
        
        //TableView
        tableView.tableFooterView = UIView()
        
        //barButtonItem
        
        let barButtonItem = UIBarButtonItem(title: "Open Maps", style: .done, target: self, action: #selector(self.openMaps))
        self.navigationItem.rightBarButtonItem = barButtonItem;
        
        self.customPopViewController();
        
        //Title
        self.title = "Steps";
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataSource.count;
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DirectionTableViewCell;
        
        cell.step = dataSource[indexPath.row];
        
        cell.loadInformation();
        
        return cell
    }
    
    
    // MARK: - SELECTORS -
    
    @objc func openMaps() {
        
        let mapsUrl = URL(string:"http://maps.apple.com/?saddr=\(Double(currentLocation.coordinate.latitude)),\(Double(currentLocation.coordinate.longitude))&daddr=\(Double((rateSelected.branchLocation?.coordinate.latitude)!)),\(Double((rateSelected.branchLocation?.coordinate.longitude)!))")!
        
        UIApplication.shared.open(mapsUrl, options: [:], completionHandler: { (done) in
            
            print("maps opened");
        })
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
