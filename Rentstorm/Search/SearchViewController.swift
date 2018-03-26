//
//  SearchViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/15/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol SearchViewControllerDelegate: class {
    
    func searchViewControllerDidSelectLocation(place:Place, startDate:Date, endDate:Date);
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchTableViewCellDelegate, ButtonTableViewCellDelegate, DateTableViewCellDelegate {

    var SEARCH_SECTION = 0;
    var NEARBY_SECTION = 1;
    var RESULTS_SECTION = 2;
    var DATES_SECTION = 3;
    var BUTTON_SECTION = 4;
    var HISTORY_SECTION = 5;
    
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //PROPERTIES
    var searchCompleter = MKLocalSearchCompleter()
    var datePicker = UIDatePicker();
    var startDateSelected = true;
    var currentPlace:Place?
    
    var placeSelected:Place?
    var startDate:Date?
    var endDate:Date?
    
    //DELEGATES
    weak var delegate:SearchViewControllerDelegate?
    
    //DATASOURCE
    var dataSource = [Place]()
    var historyList = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization();
        UIConfiguration();
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Initialization -
    
    func initialization() {
        
        //History
        historyList = LocationModel.sharedInstance.retrieveSearchHistory();
        
        //DatePicker
        addDatePicker();
        
        //CurrentLocation
        LocationModel.sharedInstance.currentPlace { (place) in
            
            self.currentPlace = place;
            
            self.tableView.reloadSections([self.NEARBY_SECTION], with: .top);
            
        }
        
        //Check dates
        if startDate == nil || endDate == nil {
            
            //Default values when dates are not passed
            
            startDate = Date()
            endDate = Date()
        }
        
        //Check if placeSelected is already assigned
        if placeSelected != nil {

            showDatePicker();
        }
        
        
    }
    
    func UIConfiguration () {
        
        //TableView
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK: - TableView DataSource|Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == SEARCH_SECTION{
            
            return 1;
        }
        
        if section == NEARBY_SECTION {
            
            if placeSelected == nil && currentPlace != nil {
                
                return 1;
            }
        }
        
        if section == RESULTS_SECTION{
            
            return dataSource.count;
        }
        
        if section == DATES_SECTION{
            
            if placeSelected != nil {
                
                return 1;
            }
        }
        
        if section == BUTTON_SECTION{
            
            if placeSelected != nil {
                
                return 1;
            }
        }
        
        if section == HISTORY_SECTION {
            
            if dataSource.count == 0  && placeSelected == nil { //Only at the beginning
                
                return historyList.count;
            }
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {


        if section == HISTORY_SECTION && placeSelected == nil {

            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20), title: "HISTORY");
        }

        return UIView();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == HISTORY_SECTION && placeSelected == nil && dataSource.count == 0 { //Only at the begining state

            return 20.0;
        }

        return 0.1;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == NEARBY_SECTION && placeSelected == nil && dataSource.count == 0 {

            return 20;
        }

        if section == RESULTS_SECTION && placeSelected != nil {
            
            return 50;
        }
        
        if section == DATES_SECTION && placeSelected != nil {
            
            return 50;
        }

        return 0.1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == SEARCH_SECTION{
            
            return 90;
        }
        
        if indexPath.section == HISTORY_SECTION {
            
            return 30;
        }
        
        if indexPath.section == DATES_SECTION{
            
            return 90;
        }
        
        if indexPath.section == BUTTON_SECTION{
            
            return 50;
        }
        
        return 45;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SEARCH_SECTION{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell;
            
            cell.delegate = self;
            
            if let placeSelected = placeSelected {
                
                cell.txt_text.text = placeSelected.name;
            }
            
            return cell;
        }
        
        if indexPath.section == RESULTS_SECTION{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
            
            //Place
            let place = dataSource[indexPath.row];
            
            cell.textLabel?.text = place.name;
            cell.detailTextLabel?.text = place.address;
            
            return cell;
        }
        
        if indexPath.section == DATES_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
            
            //StartDate
            cell.lbl_startDay.text = DatesModel.dayString(date: startDate!);
            cell.lbl_startDate.text = DatesModel.dayNumberMonthYearString(date: startDate!);
            
            //EndDate
            cell.lbl_endDay.text = DatesModel.dayString(date: endDate!);
            cell.lbl_endDate.text = DatesModel.dayNumberMonthYearString(date: endDate!);
            
            //Selection
            cell.startDaySelected = startDateSelected;
            cell.UIConfiguration()
            
            //Delegate
            cell.delegate = self;
            
            return cell;
        }
        
        if indexPath.section == BUTTON_SECTION{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonTableViewCell
            
            cell.delegate = self
            
            return cell;
        }
        
        if indexPath.section == NEARBY_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyCell", for: indexPath)
            
            return cell;
        }
        
        if indexPath.section == HISTORY_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
            
            //Place
            let place = historyList[indexPath.row];
            
            cell.textLabel?.text = place.name;
            
            return cell;
        }
        
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != DATES_SECTION && indexPath.section != BUTTON_SECTION {
            
            var place:Place?;
            
            //assign
            if indexPath.section == NEARBY_SECTION {
                
                place = currentPlace;
            }
            
            if indexPath.section == RESULTS_SECTION {
                
                place = dataSource[indexPath.row];
            }
            
            if indexPath.section == HISTORY_SECTION {
                
                place = historyList[indexPath.row];
            }
            
            //Add to local history
            LocationModel.sharedInstance.addPlaceToHistory(place: place!);
            
            //Selected place
            placeSelected = place
            
            //Empty dataSource
            dataSource.removeAll();
            
            //Show dates cells
            self.tableView.reloadSections([SEARCH_SECTION, RESULTS_SECTION, NEARBY_SECTION, HISTORY_SECTION, DATES_SECTION, BUTTON_SECTION], with: .fade);
            
            //Show picker
            showDatePicker();
        }
    }
    
    
    //MARK: - SEARCH CELL DELEGATE
    
    func searchTableViewCellDidChangeText(cell: SearchTableViewCell, text: String) {
        
        //Search
        LocationModel.sharedInstance.autocompleteWithText(text: text) { (places) in
           
            self.dataSource = places;
            self.tableView.reloadData()
            
            //Keep responder
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.SEARCH_SECTION)) as! SearchTableViewCell;
            cell.txt_text.becomeFirstResponder();

        };
        
        if text.count == 0 {
            
            self.dataSource = []
            self.tableView.reloadData();
            
            //Keep responder
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.SEARCH_SECTION)) as! SearchTableViewCell;
            cell.txt_text.becomeFirstResponder();
        }
        
        
    }
    
    //MARK: - DATE CELL DELEGATE
    
    func startDaySelected() {
        
        datePicker.date = startDate!;
    }
    
    func endDaySelected() {
        
        datePicker.date = endDate!;
    }
    
    //MARK: - BUTTON CELL DELEGATE -
    
    func buttonTableViewCellDidTapped(cell: ButtonTableViewCell) {
        
        //Search rates
        
        delegate?.searchViewControllerDidSelectLocation(place: placeSelected!, startDate: startDate!, endDate: endDate!);
        
        //dismiss
        dismiss(animated: true, completion: nil);
        
    }
    
    //MARK: - DATE PICKER -
    
    func addDatePicker() {
        
        //Create
        datePicker.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white;
        datePicker.addTarget(self, action: #selector(SearchViewController.datePickerChangedValue(datePicker:)), for: .valueChanged);
        
        view.addSubview(datePicker);
    }
    
    func showDatePicker() {
        
        //Hide keyboard
        self.view.endEditing(true);
        
        UIView.animate(withDuration: 0.3) {
            
            self.datePicker.frame = CGRect(x: 0, y: (self.view.frame.height - 200), width: self.view.frame.width, height: 200)
        }
    }
    
    
    func hideDatePicker() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.datePicker.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 200)
        }
        
    }

    @objc func datePickerChangedValue(datePicker:UIDatePicker) {

        //Get cell
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: DATES_SECTION)) as! DateTableViewCell;
        
        //update flag
        startDateSelected = cell.startDaySelected;
        
        if cell.startDaySelected {

            if datePicker.date >= Date() { //Avoid older dates than today
                
                //Update property
                startDate = datePicker.date;
                
                //Update cell
                cell.lbl_startDay.text = DatesModel.dayString(date: startDate!);
                cell.lbl_startDate.text = DatesModel.dayNumberMonthYearString(date: startDate!);
            
            }else{
                
                datePicker.date = Date();
                
                //
                startDate = Date();
                
                //Update cell
                cell.lbl_startDay.text = DatesModel.dayString(date: Date());
                cell.lbl_startDate.text = DatesModel.dayNumberMonthYearString(date: Date());
            }
            
            
            
        }else{
            
            if datePicker.date > startDate! { //endDate cannot be less than the startDate
                
                //Update property
                endDate = datePicker.date;
                
                //update cell
                cell.lbl_endDay.text = DatesModel.dayString(date: endDate!);
                cell.lbl_endDate.text = DatesModel.dayNumberMonthYearString(date: endDate!);
            
            }else{
                
                datePicker.date = (startDate?.tomorrow)!
                
                endDate = (startDate?.tomorrow)!
                
                //update cell
                cell.lbl_endDay.text = DatesModel.dayString(date: endDate!);
                cell.lbl_endDate.text = DatesModel.dayNumberMonthYearString(date: endDate!);
            }
            
            
        }
        
    }
    //MARK: - ACTIONS -
    
    @IBAction func closeVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func startAgain(_ sender: Any) {
        
        //DataSource
        dataSource.removeAll()
        
        //Update history
        historyList = LocationModel.sharedInstance.retrieveSearchHistory()
        
        //Remove place
        placeSelected = nil;
        
        //Remove dates
        startDate = Date();
        endDate = Date();
        
        //Remove text
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: SEARCH_SECTION)) as! SearchTableViewCell;
        cell.txt_text.text = "";
        
        //Hide picker
        hideDatePicker();
        
        //reload
        tableView.reloadData();
        
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
