//
//  DatesPickerViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/18/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

protocol DatesPickerViewControllerDelegate: class {
    
    func datesPickerViewControllerDidSelectDates(startDate:Date, endDate:Date);
}

class DatesPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DateTableViewCellDelegate, ButtonTableViewCellDelegate {

    var DATES_SECTION = 0;
    var BUTTON_SECTION = 1;
    
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //PROPERTIES
    var datePicker = UIDatePicker();
    var startDateSelected = true;
    
    var startDate = Date() //Default
    var endDate = Date() //Default
    
    //DELEGATES
    weak var delegate:DatesPickerViewControllerDelegate?
    

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

        //DatePicker
        addDatePicker();
        showDatePicker();

    }
    
    func UIConfiguration () {
        
        //TableView
        tableView.tableFooterView = UIView()
    }
    
    
    
    //MARK: - TableView DataSource|Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 90;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == DATES_SECTION {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateTableViewCell
            
            //StartDate
            cell.lbl_startDay.text = DatesModel.dayString(date: startDate);
            cell.lbl_startDate.text = DatesModel.dayNumberMonthYearString(date: startDate);
            
            //EndDate
            cell.lbl_endDay.text = DatesModel.dayString(date: endDate);
            cell.lbl_endDate.text = DatesModel.dayNumberMonthYearString(date: endDate);
            
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
        
        return UITableViewCell();
    }

    
    //MARK: - DATE CELL DELEGATE
    
    func startDaySelected() {
        
        datePicker.date = startDate;
    }
    
    func endDaySelected() {
        
        datePicker.date = endDate;
    }
    
    //MARK: - BUTTON CELL DELEGATE -
    
    func buttonTableViewCellDidTapped(cell: ButtonTableViewCell) {
        //Dates
        
        delegate?.datesPickerViewControllerDidSelectDates(startDate: startDate, endDate: endDate)
        
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
        
        //Date
        datePicker.date = startDate;
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
                cell.lbl_startDay.text = DatesModel.dayString(date: startDate);
                cell.lbl_startDate.text = DatesModel.dayNumberMonthYearString(date: startDate);
                
            }else{
                
                datePicker.date = Date();
                
                //
                startDate = Date();
                
                //Update cell
                cell.lbl_startDay.text = DatesModel.dayString(date: Date());
                cell.lbl_startDate.text = DatesModel.dayNumberMonthYearString(date: Date());
            }
            
            
            
        }else{
            
            if datePicker.date > startDate { //endDate cannot be less than the startDate
                
                //Update property
                endDate = datePicker.date;
                
                //update cell
                cell.lbl_endDay.text = DatesModel.dayString(date: endDate);
                cell.lbl_endDate.text = DatesModel.dayNumberMonthYearString(date: endDate);
                
            }else{
                
                datePicker.date = startDate.tomorrow
                
                endDate = startDate.tomorrow
                
                //update cell
                cell.lbl_endDay.text = DatesModel.dayString(date: endDate);
                cell.lbl_endDate.text = DatesModel.dayNumberMonthYearString(date: endDate);
            }
            
            
        }
        
    }
    
    //MARK: - ACTIONS -
//
//    func validation() {
//
//        if startDate < endDate {
//
//            //Enable
//
//            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: BUTTON_SECTION)) as! ButtonTableViewCell;
//            cell.btn_button.isEnabled = true;
//
//            cell.btn_button.setTitleColor(#colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1), for: .normal)
//            cell.btn_button.layer.borderColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
//
//        }else{
//
//            //Disable
//
//            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: BUTTON_SECTION)) as! ButtonTableViewCell;
//            cell.btn_button.isEnabled = false;
//
//            cell.btn_button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
//            cell.btn_button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        }
//    }
//
//
    
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
