//
//  FilterViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/22/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    
    func filterViewControllerDidFiler(filteredArray:[Rate], filterApplied:Filter);
    func filterViewControllerDidRemoveFilters()
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    var RATES_SECTION = 0;
    var SIZES_SECTION = 1;
    var transmission_SECTION = 2;
    
    var rates = [Rate]();
    var ratesFiltered = [Rate]();
    
    //DATASOURCE
    var rateTypes = [String]();
    var sizes = [String]();
    var transmission = [String]();
    
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_button: UIButton!
    
    //Filter
    var filter:Filter!
    
    //DELEGATE
    weak var delegate:FilterViewControllerDelegate?
    
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
        
        //Init
        self.btn_button.setTitle("Show \(rates.count)", for: .normal);
        
        //Bar buttons
        let rightItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(self.removeFilters))
        rightItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .regular)], for: .normal)
        rightItem.tintColor = UIColor.black;
        
        self.navigationItem.rightBarButtonItem = rightItem;
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.closeVC(_:)), for: .touchUpInside);
        
        let leftBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let width = leftBarButton.customView?.widthAnchor.constraint(equalToConstant: 22)
        width?.isActive = true
        let height = leftBarButton.customView?.heightAnchor.constraint(equalToConstant: 22)
        height?.isActive = true
        
        //Filter
        if self.filter == nil {
            
            self.filter = Filter()
        }
    }
    
    func UIConfiguration () {
        
        //TableView
        tableView.tableFooterView = UIView();
        
        //Button
        btn_button.layer.borderWidth = 2;
        btn_button.layer.borderColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
        btn_button.layer.cornerRadius = btn_button.frame.height / 2
    }
    
    
    //MARK: - TableView DataSource|Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == RATES_SECTION {
            
            return rateTypes.count;
        }
        
        if section == SIZES_SECTION {
            
            return sizes.count;
        }
        
        if section == transmission_SECTION {
            
            return transmission.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == RATES_SECTION {
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "RATES");
        }
        
        if section == SIZES_SECTION {
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "SIZES");
        }
        
        if section == transmission_SECTION {
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "transmission");
        }
        
        return UIView();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == SIZES_SECTION {
            
            return 80
            
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == RATES_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath);
            
            cell.textLabel?.text = rateTypes[indexPath.row];
            
            //Selection
            cell.accessoryType = .none;
            if self.filter.rates.contains(rateTypes[indexPath.row]) {
                
                cell.accessoryType = .checkmark;
            }
            
            return cell;
        }
        
        if indexPath.section == SIZES_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! InfoTableViewCell;
            
            //Car
            cell.img_image.image = UIImage.init(named: sizes[indexPath.row]);
            
            //Title
            cell.lbl_title.text = Rate.carCategory(category: sizes[indexPath.row]).rawValue
            
            //Car
            cell.lbl_subtitle.text = Rate.suggestedVehicleName(category: Rate.carCategory(category: sizes[indexPath.row]));
            
            //Selection
            cell.accessoryType = .none;
            if self.filter.sizes.contains(sizes[indexPath.row]) {
                
                cell.accessoryType = .checkmark;
            }
            
            return cell;
            
        }
        
        if indexPath.section == transmission_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath);
            
            cell.textLabel?.text = transmission[indexPath.row];
            
            //Selection
            cell.accessoryType = .none;
            if self.filter.transmission.contains(transmission[indexPath.row]) {
                
                cell.accessoryType = .checkmark;
            }
            
            return cell;
        }
        
        return UITableViewCell();
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == RATES_SECTION {
            
            if self.filter.rates.contains(rateTypes[indexPath.row]) {
                
                //Remove it
                self.filter.rates.remove(at: self.filter.rates.index(of: rateTypes[indexPath.row])!);
            
            }else{
                
                //Add it
                self.filter.rates.append(rateTypes[indexPath.row]);
            }
        }
        
        if indexPath.section == SIZES_SECTION {
            
            if filter.sizes.contains(sizes[indexPath.row]) {
                
                //Remove it
                filter.sizes.remove(at: self.filter.sizes.index(of: sizes[indexPath.row])!);
                
            }else{
                
                //Add it
                filter.sizes.append(sizes[indexPath.row]);
            }
            
        }
        
        if indexPath.section == transmission_SECTION {
            
            if self.filter.transmission.contains(transmission[indexPath.row]) {
                
                //Remove it
                filter.transmission.remove(at: self.filter.transmission.index(of: transmission[indexPath.row])!);
                
            }else{
                
                //Add it
                self.filter.transmission.append(transmission[indexPath.row]);
            }
            
        }
        
        //Filter
        applyFilter();
        
        //Reload cell
        tableView.reloadRows(at: [indexPath], with: .none);
        
    }
    
    
    //MARK: - Filtering -
    
    func applyFilter() {
        
        //Clear all
        ratesFiltered.removeAll();
        
        //Add all
        ratesFiltered.append(contentsOf: rates);
        
        
        //Rates
        if self.filter.rates.count > 0 {
            
            ratesFiltered = ratesFiltered.filter({
                
                self.filter.rates.contains(($0.rateType?.rawValue)!);
            })
        }

        
        //Sizes
        
        if self.filter.sizes.count > 0 {
            
            ratesFiltered = ratesFiltered.filter({
                
                self.filter.sizes.contains(($0.category?.rawValue)!);
            })
        }
        
        
        //Transmition
        
        if self.filter.transmission.count > 0 {
            
            ratesFiltered = ratesFiltered.filter({
                
                self.filter.transmission.contains(($0.transmission?.rawValue)!);
            })
            
        }
        
        //Button
        self.btn_button.setTitle("Show \(ratesFiltered.count)", for: .normal);
    }
    
    
    //MARK: - Selectors -
    
    @objc func removeFilters() {
        
        //Remove all
        self.filter.removeFilters();
        
        //Keep all rates in here
        self.ratesFiltered.append(contentsOf: self.rates);

        //Reload
        self.tableView.reloadData();
        
        //Delegate
        delegate?.filterViewControllerDidRemoveFilters();
        
        //Button
        self.btn_button.setTitle("Show \(ratesFiltered.count)", for: .normal);
        
    }
    
    
    //MARK: - ACTIONS -
    @IBAction func sendFilter(_ sender: Any) {
        
        delegate?.filterViewControllerDidFiler(filteredArray: ratesFiltered, filterApplied: self.filter);
        
        self.dismiss(animated: true, completion: nil);
    }
    
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
