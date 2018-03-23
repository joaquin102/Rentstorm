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

class RatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, SearchViewControllerDelegate, SortViewControllerDelegate, DatesPickerViewControllerDelegate, RatePreviewViewControllerDelegate {
    
    var INCOMING_RESERVATIONS_SECTION = 0;
    var RATES_SECTION = 1;
    
    //PROPERTIES
    var dataSource:[Rate] = [];
    var nearbyRates:[Rate] = [];
    
    var rateSelected:Rate?
    var placeSelected:Place? //Place or area where the customer wants to see rates
    var startDate = Date().tomorrow //Default
    var endDate = Date().dayAfterTomorrow //Default
    
    var sort:SortTypes = .distance //Default
    

    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewActivityContainer: UIView!
    @IBOutlet weak var viewActivityIndicator: NVActivityIndicatorView!
    
    
    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var lbl_searchTitle: UILabel!
    
    @IBOutlet weak var viewDatesContainer: UIView!
    @IBOutlet weak var viewFiltersContainer: UIView!
    @IBOutlet weak var viewSortContainer: UIView!
    @IBOutlet weak var lbl_filters: UILabel!
    @IBOutlet weak var lbl_dates: UILabel!
    @IBOutlet weak var lbl_sort: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialization()
        UIConfiguration()
        ratesNearby()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Initialization -
    
    func initialization() {
        
        //Gestures
        let tapGestureSearch = UITapGestureRecognizer(target: self, action: #selector(self.openSearch));
        viewSearchContainer.addGestureRecognizer(tapGestureSearch);
        
        let tapGestureDates = UITapGestureRecognizer(target: self, action: #selector(self.openDates));
        viewDatesContainer.addGestureRecognizer(tapGestureDates);
        
        let tapGestureSort = UITapGestureRecognizer(target: self, action: #selector(self.openSort));
        viewSortContainer.addGestureRecognizer(tapGestureSort);
        
        let tapGestureFilters = UITapGestureRecognizer(target: self, action: #selector(self.openFilters));
        viewFiltersContainer.addGestureRecognizer(tapGestureFilters);
    }
    
    func UIConfiguration() {
        
        //TableView
        tableView.tableFooterView = UIView()
        tableView.backgroundView = viewActivityContainer;
        
        //Search Box
        self.viewSearchContainer.layer.shadowColor = #colorLiteral(red: 0.7342769883, green: 0.7342769883, blue: 0.7342769883, alpha: 1)
        self.viewSearchContainer.layer.shadowRadius = 0.5;
        self.viewSearchContainer.layer.shadowOpacity = 0.8;
        self.viewSearchContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        //Containers
        viewDatesContainer.layer.cornerRadius = 5;
        viewSortContainer.layer.cornerRadius = 5;
        viewFiltersContainer.layer.cornerRadius = 5;
        
        viewDatesContainer.alpha = 0;
        
        //Update
        updateSortButton()
        updateDatesButton()
        
        //Logo
        self.showRentStormLogo();
    }
    
    
    //MARK: - ServerData -
    
    func ratesNearby() {
        
        viewActivityIndicator.startAnimating();
        
        //Get current place
        LocationModel.sharedInstance.currentPlace(block: { (currentPlace) in
            
            //Assign current place
            self.placeSelected = currentPlace
            
            //Get nearby rates
            ServerModel.rates(location: currentPlace.location!, startDate:self.startDate, endDate:self.endDate, block: { (rates) in
                
                if rates.count > 0 {
                    
                    //Sort by default (Distance)
                    self.dataSource = self.sortedRates(rates: rates)
                    
                    self.nearbyRates = self.sortedRates(rates: rates) //Keep a copy
                    
                    //Update TableView
                    self.tableView.reloadSections(IndexSet.init(integer: self.RATES_SECTION), with: UITableViewRowAnimation.fade)
                    
                    //Stop animating
                    self.viewActivityIndicator.stopAnimating();
                
                }else{
                    
                    //Empty state
                    
                    self.viewActivityIndicator.stopAnimating();
                    
                    print("CHANGE DATES - SOMETIMES API DOESNT RETURN RESULTS WHEN DATES ARE TOO CLOSE");
                    
                }
                
                
                
            })
            
        })
        
    }
    
    func rates(place:Place, startDate:Date, endDate:Date) {
        
        //Remove all current rates
        self.dataSource.removeAll()
        tableView.reloadData()
        
        //Animate process
        self.viewActivityIndicator.startAnimating()
        
        //Assign
        self.placeSelected = place
        self.startDate = startDate;
        self.endDate = endDate;
        
        ServerModel.rates(place: place, startDate: startDate, endDate: endDate) { (rates) in
            
            //Sort them with the current selected sort
            self.dataSource = self.sortedRates(rates: rates)
            
            self.tableView.reloadSections(IndexSet.init(integer: self.RATES_SECTION), with: UITableViewRowAnimation.fade)
            
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
        
        if section == RATES_SECTION {
            
            return dataSource.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == INCOMING_RESERVATIONS_SECTION {
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "INCOMING RESERVATIONS");
        }
        
        if section == RATES_SECTION {
            
            if placeSelected != nil {
                
                return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "RESULTS");
            }
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "NEAR YOU");
        }
        
        return UIView();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == INCOMING_RESERVATIONS_SECTION {
            
            return 0.0
        }
        
        if section == RATES_SECTION {
            
            if dataSource.count > 0 {
                
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
        
        if indexPath.section == RATES_SECTION {
            
            return 360.0;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == INCOMING_RESERVATIONS_SECTION {
            
            return UITableViewCell();
        }
        
        if indexPath.section == RATES_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath) as! RateTableViewCell;
            
            //Assign
            cell.rate = dataSource[indexPath.row];
            
            //Load
            cell.loadInformation();
            
            
            //Return
            return cell;
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //rate
        rateSelected = dataSource[indexPath.row]
        
        //Open rate preview
        performSegue(withIdentifier: "ratePreviewVC", sender: self);
        
    }
    
    //MARK: - SEARCH DELEGATES -

    func searchViewControllerDidSelectNearbyRentals() {
         
    }
    
    func searchViewControllerDidSelectLocation(place: Place, startDate: Date, endDate: Date) {
        
        //Update pointers
        placeSelected = place;
        self.startDate = startDate;
        self.endDate = endDate
        
        //Get rates
        rates(place: place, startDate: startDate, endDate: endDate);
        
        
        //Update searchBar
        updateSearchBar();
        
    }
    
    //MARK: - SORT DELEGATE -
    
    func sortViewControllerDidSelectSort(sort: SortTypes) {
        
        //Change pointer
        self.sort = sort
        
        //Sort dataSource
        self.dataSource = sortedRates(rates: self.dataSource)
        
        //Reload TableView
        self.tableView.reloadData();
        
        //Scroll to top
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
        
        //Update searchBar
        updateSortButton()
    }
    
    //MARK: - DATES PICKER DELEGATE -
    
    func datesPickerViewControllerDidSelectDates(startDate: Date, endDate: Date) {
        
        //assign
        self.startDate = startDate;
        self.endDate = endDate;
        
        //Update dates button
        updateDatesButton()
        
        //Get rate
        rates(place: placeSelected!, startDate: startDate, endDate: endDate);
    }
    
    
    //MARK: - RATE PREVIEW DELEGATE -
    
    func ratePreviewViewControllerDidChangeDates(startDate: Date, endDate: Date) {
        
        //assign
        self.startDate = startDate;
        self.endDate = endDate;
        
        //Get rate
        rates(place: placeSelected!, startDate: startDate, endDate: endDate);
    }
    
    //MARK: - SORTING -
    
    func sortedRates(rates:[Rate]) -> [Rate] {
        
        if self.sort == .lowestPrice {
            
            return rates.sorted(by: {
                
                $0.total! < $1.total!;
            })
        }
        
        if self.sort == .highestPrice {
            
            return rates.sorted(by: {
                
                $0.total! > $1.total!;
            })
        }
        
        if self.sort == .company {
            
            return rates.sorted(by: {
                
                $0.company! < $1.company!;
            })
        }
        
        if self.sort == .distance {
            
            return rates.sorted(by: {
                
                $0.distanceToBranch! < $1.distanceToBranch!;
            })
        }
        
        return [];
        
    }
    
    
    
    //MARK: - GESTURES -
    
   @objc func openSearch() {
        
        performSegue(withIdentifier: "searchVC", sender: self)
    }
    
    @objc func openDates() {
        
        performSegue(withIdentifier: "datesVC", sender: self)
    }
    
    @objc func openSort() {
        
        if dataSource.count > 0 {
            
            performSegue(withIdentifier: "sortVC", sender: self)
        }
        
    }
    
    @objc func openFilters() {
        
        if dataSource.count > 0 {
            
            performSegue(withIdentifier: "filterVC", sender: self)
        }
        
    }
    
    
    
    //MARK: - SEARCH BAR -

    
    func updateSearchBar() {
        
        //Place selecrted
        
        if placeSelected != nil {
            
            lbl_searchTitle.text = placeSelected?.name;
            lbl_searchTitle.textColor = #colorLiteral(red: 0.1096785946, green: 0.1096785946, blue: 0.1096785946, alpha: 1)
            
            //Change icon
            btn_search.setImage(#imageLiteral(resourceName: "Back"), for: .normal);
            btn_search.imageView?.contentMode = .scaleAspectFit;
            
        }else{
            
            lbl_searchTitle.text = "Try a city or an address";
            lbl_searchTitle.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            //Change icon
            btn_search.setImage(#imageLiteral(resourceName: "Search"), for: .normal);
            btn_search.imageView?.contentMode = .scaleAspectFit;
        }

    }
    
    func updateSortButton() {
        
        //Sort
        lbl_sort.text = "Sort · " + sort.rawValue
        lbl_sort.textColor = UIColor.white;
        viewSortContainer.backgroundColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
    }
    
    func updateDatesButton() {
        
        //Dates
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMM dd"
        
        // Apply date format
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        //Dates range
        lbl_dates.text = startDateString + " - " + endDateString;
        lbl_dates.textColor = UIColor.white;
        viewDatesContainer.backgroundColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
        viewDatesContainer.alpha = 1;
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        //Remove
        placeSelected = nil;
        startDate = Date();
        endDate = Date();
        sort = .distance;
        
        //Update searchBar
        updateSearchBar();
        updateDatesButton()
        updateSortButton()
        
        //Show nearby results
        dataSource = nearbyRates;
        self.tableView.reloadSections([INCOMING_RESERVATIONS_SECTION, RATES_SECTION], with: .top);

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchVC" {
            
            let searchVC = segue.destination as! SearchViewController;
            searchVC.startDate = startDate;
            searchVC.endDate = endDate;
            searchVC.delegate = self;
        }
        
        if segue.identifier == "datesVC" {
            
            let datesVC = segue.destination as! DatesPickerViewController;
            datesVC.delegate = self;
            datesVC.startDate = startDate;
            datesVC.endDate = endDate;
        }
        
        if segue.identifier == "sortVC" {
            
            let sortVC = segue.destination as! SortViewController;
            sortVC.delegate = self;
            sortVC.sort = self.sort;
        }
        
        if segue.identifier == "ratePreviewVC" {
            
            let previewVC = segue.destination as! RatePreviewViewController;
            previewVC.rateSelected = self.rateSelected
            previewVC.delegate = self;
            
        }
    }


}

extension Date {

    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var dayAfterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

}


