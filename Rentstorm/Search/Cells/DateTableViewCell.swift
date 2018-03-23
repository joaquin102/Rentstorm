//
//  DateTableViewCell.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/17/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

protocol DateTableViewCellDelegate: class {
    
    func startDaySelected()
    func endDaySelected()
}

class DateTableViewCell: UITableViewCell {

    //Start date
    @IBOutlet weak var img_startDate: UIImageView!
    @IBOutlet weak var lbl_startDay: UILabel!
    @IBOutlet weak var lbl_startDate: UILabel!
    @IBOutlet weak var viewSelectionStartDate: UIView!
    @IBOutlet weak var viewStartDateContainer: UIView!
    
    //End date
    @IBOutlet weak var img_endDate: UIImageView!
    @IBOutlet weak var lbl_endDay: UILabel!
    @IBOutlet weak var lbl_endDate: UILabel!
    @IBOutlet weak var viewSelectionEndDate: UIView!
    @IBOutlet weak var viewEndDateContainer: UIView!
    
    weak var delegate:DateTableViewCellDelegate?
    
    //Properties
    var startDaySelected = false;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Initial UI
        UIConfiguration();
        
        
        //Gestures
        let tapGestureStartDate = UITapGestureRecognizer(target: self, action: #selector(DateTableViewCell.selectStartDate));
        viewStartDateContainer.addGestureRecognizer(tapGestureStartDate);
        
        let tapGestureEndDate = UITapGestureRecognizer(target: self, action: #selector(DateTableViewCell.selectEndDate));
        viewEndDateContainer.addGestureRecognizer(tapGestureEndDate);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //UIConfiguration
    
    func UIConfiguration() {
        
        if startDaySelected == true {
            
            //Start day
            img_startDate.image = img_startDate.image?.withRenderingMode(.alwaysTemplate);
            img_startDate.tintColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
            
            lbl_startDay.textColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
            lbl_startDate.textColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
            
            viewSelectionStartDate.backgroundColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
            
            //End day
            img_endDate.image = img_endDate.image?.withRenderingMode(.alwaysTemplate);
            img_endDate.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            lbl_endDay.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
            lbl_endDate.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
            
            viewSelectionEndDate.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        }else {
            
            //Start day
            img_startDate.image = img_startDate.image?.withRenderingMode(.alwaysTemplate);
            img_startDate.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            lbl_startDay.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            lbl_startDate.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            viewSelectionStartDate.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            //End day
            img_endDate.image = img_endDate.image?.withRenderingMode(.alwaysTemplate);
            img_endDate.tintColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
            
            lbl_endDay.textColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1);
            lbl_endDate.textColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1);
            
            viewSelectionEndDate.backgroundColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
        }
    }
    
    //MAKR: - Gestures -
    
    @objc func selectStartDate() {
        
        startDaySelected = true;
        UIConfiguration();
        
        //Delegate
        delegate?.startDaySelected()
        
    }
    
    @objc func selectEndDate() {
        
        startDaySelected = false;
        UIConfiguration();
        
        //Delegate
        delegate?.endDaySelected()
    }
    
}
