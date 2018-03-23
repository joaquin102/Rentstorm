//
//  SortViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/17/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

enum SortTypes:String {
    
    case lowestPrice = "Lowest Price"
    case highestPrice = "Highest Price"
    case company = "Company"
    case distance = "Distance"
    
}

protocol SortViewControllerDelegate: class {
    
    func sortViewControllerDidSelectSort(sort:SortTypes)
}

class SortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Properties
    var sort:SortTypes?
    
    //DATASOURCE
    var dataSource = [SortTypes]()
    
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //DELEGATE
    weak var delegate:SortViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        UIConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    //MARK: - Initialization -
    
    func initialization() {
        
        //Fill out dataSource
        dataSource = [.lowestPrice, .highestPrice, .company, .distance];
        
    }
    
    func UIConfiguration () {
        
        //TableView
        tableView.tableFooterView = UIView();
    }
    
    
    //MARK: - TableView DataSource|Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        
        let sortType = dataSource[indexPath.row];
        
        //Name
        cell.textLabel?.text = sortType.rawValue;
        
        //Selection
        cell.accessoryType = .none;
        
        if sort == sortType {
            
            cell.accessoryType = .checkmark
        }
        
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sortSelected = dataSource[indexPath.row];
        
        if sort != sortSelected {
            
            //Change
            sort = sortSelected
            
            //Notify delegate
            delegate?.sortViewControllerDidSelectSort(sort: sortSelected)
        }
        
        //DIsmiss
        dismiss(animated: true, completion: nil);
        
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func closeVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
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
