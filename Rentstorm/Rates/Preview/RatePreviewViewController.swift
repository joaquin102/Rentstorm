//
//  RatePreviewViewController.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/18/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import CoreLocation

protocol RatePreviewViewControllerDelegate: class {
    
    func ratePreviewViewControllerDidChangeDates(startDate:Date, endDate:Date);
}

class RatePreviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonTableViewCellDelegate, DatesPickerViewControllerDelegate {

    var RATE_SECTION = 0;
    var BUTTON_SECTION = 1;
    var SIMILAR_RATES = 2;
    
    //PROPERTIES
    var dataSource:[Rate] = [];
    var reservationConfirmed = false;
    
    //Delegate
    weak var delegate:RatePreviewViewControllerDelegate?
    
    var rateSelected:Rate!
    
    //Location
    var locationManager:CLLocationManager!
    
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        UIConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initialization() {
        

    }
    
    func UIConfiguration() {
        
        
        //TableView
        tableView.tableFooterView = UIView()
        
        //Bar
        self.customPopViewController();
        
        //Logo
        self.showRentStormLogo()

    }
    
    //MARK: - Server Data -
//
//    func rates() {
//
//        ServerModel.rates(place: placeSelected!, startDate: (rateSelected?.startDate)!, endDate: (rateSelected?.endDate)!) { (rates) in
//
//            //Find this exact rate
//            let filteredRates = rates.filter({
//
//                $0.branchAddress == self.rateSelected?.branchAddress && $0.suggestedName == self.rateSelected?.suggestedName && $0.company == self.rateSelected?.company
//            })
//
//            let similarRates = rates.filter({
//
//                $0.branchAddress == self.rateSelected?.branchAddress && $0.suggestedName == self.rateSelected?.suggestedName
//            })
//
//            if filteredRates.count > 0 {
//
//                self.rateSelected = filteredRates.first;
//
//                self.tableView.reloadData();
//
//            }else{
//
//                //Show info
//
//            }
//
//
//
//        }
//    }
    
    
    //MARK: - TableView Datasource|Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == RATE_SECTION {
            
            return 1;
        }
        
        if section == BUTTON_SECTION {
            
            if reservationConfirmed {
                
                return 1;
            }
            
            return 2;
        }
        
        if section == SIMILAR_RATES {
            
            return dataSource.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == SIMILAR_RATES {
            
            return TableViewHeader.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50), title: "SIMILAR RATES");
        }
        
        return UIView();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == SIMILAR_RATES {
            
            if dataSource.count > 0 {
                
                return 50.0;
            }
        }
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == RATE_SECTION {
            
            if reservationConfirmed {
                
                return 480;
            }
            
            return 380.0;
        }
        
        if indexPath.section == BUTTON_SECTION {
            
            return 100;
        }
        
        if indexPath.section == SIMILAR_RATES {
            
            return 360.0;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == RATE_SECTION || indexPath.section == SIMILAR_RATES {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath) as! RateTableViewCell;
            
            //Assign
            cell.rate = self.rateSelected;
            
            //Load
            cell.loadInformation();
            
            //Block for location
            cell.companyLocation(block: { (branchLocation) in
                
                //Open map
                self.performSegue(withIdentifier: "mapVC", sender: self)
            })
            
            //Return
            return cell;
        }
        
        if indexPath.section == BUTTON_SECTION {
            
            if reservationConfirmed {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "directionsButtonCell", for: indexPath) as! ButtonTableViewCell
                
                cell.delegate = self
                
                return cell;
                
            }else {
                
                if indexPath.row == 0 {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "rentButtonCell", for: indexPath) as! ButtonTableViewCell
                    
                    cell.delegate = self
                    
                    cell.lbl_text.text = dateString(date: rateSelected.startDate!) + " - " + dateString(date: rateSelected.endDate!);
                    
                    return cell;
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateButtonCell", for: indexPath) as! ButtonTableViewCell
                
                cell.delegate = self
                
                return cell;
            }
            
            
            
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == SIMILAR_RATES {

        }
    }
    
    
    //MARK: - DATES PICKER DELEGATE -
    
    func datesPickerViewControllerDidSelectDates(startDate: Date, endDate: Date) {
        
        if rateSelected.startDate != startDate || rateSelected.endDate != endDate {
            
            delegate?.ratePreviewViewControllerDidChangeDates(startDate: startDate, endDate: endDate);
            
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    //MARK: - BUTTON CELL DELEGATE -
    
    func buttonTableViewCellDidTapped(cell: ButtonTableViewCell) {
        
        if reservationConfirmed {
            
            //GPS directions
            performSegue(withIdentifier: "mapVC", sender: self);
            
            
        }else{
            
            if tableView.indexPath(for: cell)?.row == 1 {
                
                //Open dates picker
                performSegue(withIdentifier: "datesVC", sender: self);
                
            }else{
                
                //Show popUp
                let popUp = PopUpConfirmation.init(rate: rateSelected!);
                navigationController?.view.addSubview(popUp);
                
                popUp.showPopUp()
                
                //Blcok for answer
                popUp.confirmation(block: { (successful) in

                    //Change flag
                    self.reservationConfirmed = true;
                    
                    //Button section
                    self.tableView.reloadSections([self.BUTTON_SECTION], with: .fade);
                    
                    //Change height
                    self.tableView.beginUpdates();
                    self.tableView.endUpdates();
                    
                    //Update cell
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.RATE_SECTION)) as! RateTableViewCell;
                    cell.showConfirmationContainer();

                })
            }
        }
        
        
        
    }

    
    //MARK: - Helpers -
    
    func dateString(date:Date) -> String {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMM dd/yyyy"
        
        // Apply date format
        let string: String = dateFormatter.string(from: date)
        
        return string;
    }

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "datesVC" {
            
            let datesVC = segue.destination as! DatesPickerViewController
            datesVC.delegate = self;
        }
        
        if segue.identifier == "mapVC" {
            
            let mapVC = segue.destination as! MapViewController
            mapVC.rateSelected = rateSelected;
        }
    }


}

extension UIViewController {
    
    func customPopViewController() {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = UIColor.white;
        button.addTarget(self, action: #selector(self.popViewController), for: .touchUpInside);
        
        let lefttBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = lefttBarButton
        
        let width = lefttBarButton.customView?.widthAnchor.constraint(equalToConstant: 22)
        width?.isActive = true
        let height = lefttBarButton.customView?.heightAnchor.constraint(equalToConstant: 22)
        height?.isActive = true
    }
    
    func showRentStormLogo() {
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        
        let imageView = UIImageView(frame: logoContainer.frame)
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Logo")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
        
    }
    
    @objc func popViewController() {
        
        self.navigationController?.popViewController(animated: true);
    }
    
}

