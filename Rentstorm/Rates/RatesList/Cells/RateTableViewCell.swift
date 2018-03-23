//
//  RateTableViewCell.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/14/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import CoreLocation

class RateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbl_carName: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_rateType: UILabel!
    
    @IBOutlet weak var img_company: UIImageView!
    @IBOutlet weak var img_car: UIImageView!
    
    @IBOutlet weak var lbl_people: UILabel!
    @IBOutlet weak var lbl_luggage: UILabel!
    @IBOutlet weak var lbl_trans: UILabel!
    @IBOutlet weak var lbl_ac: UILabel!
    
    @IBOutlet weak var viewDistanceContainer: UIView!
    @IBOutlet weak var lbl_distance: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var viewCompanyInfoContainer: UIView!
    
    @IBOutlet weak var topConfirmationConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConfirmationConstraint: NSLayoutConstraint!
    
    
    var rate:Rate!
    
    //Blocks
    var companyLocationBlock: ((_ location:CLLocation) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //Gesture
        let tapGestureCompany = UITapGestureRecognizer(target: self, action: #selector(self.companyLocationGesture))
        
        if let view = self.viewCompanyInfoContainer {
            
            view.addGestureRecognizer(tapGestureCompany);
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Information -
    
    func loadInformation () {
        
        //Company
        img_company.image = UIImage.init(named: rate.company!);
        lbl_address.text = rate.branchAddress;
        
        //Distance
        lbl_distance.text = String(describing: rate.distanceToBranch!.roundToDecimal(1)) + " Miles";
        
        //Name
        lbl_carName.text = rate.suggestedName;
        
        //Rate Price
        lbl_price.text = "\(rate.currency!)\(rate.totalString!)";
        
        //Image
        img_car.image = UIImage.init(named: rate.category!.rawValue);
        
        //Features
        lbl_people.text = String(describing: rate.people!);
        lbl_luggage.text = String(describing: rate.luggage!);
        lbl_trans.text = String(describing: rate.transmission.rawValue);
        
        if rate.ac! {
            
            lbl_ac.text = "A/C";
        
        }else{
            
            lbl_ac.text = "NO"
        }        
        
    }
    
    //MARK: - UI -
    
    func showConfirmationContainer() {
        
        heightConfirmationConstraint.constant = 60;
        topConfirmationConstraint.constant = 30;
        
        UIView.animate(withDuration: 0.3) {
            
            self.layoutIfNeeded();
        }
    }
    
    //MARK: - Public blocks
    
    func companyLocation(block:@escaping (_ location:CLLocation) -> Void) {
        
        self.companyLocationBlock = block;
    }
    
    //MARK: - Selector -
    
    @objc func companyLocationGesture() {
        
        self.companyLocationBlock!(rate.branchLocation!);
    }

}

