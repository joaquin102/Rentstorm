//
//  SearchTableViewCell.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/15/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit


protocol SearchTableViewCellDelegate: class {
    
    func searchTableViewCellDidChangeText(cell:SearchTableViewCell, text:String);
}

class SearchTableViewCell: UITableViewCell {
    
    
    
    //OUTLETS
    @IBOutlet weak var txt_text: UITextField!
    
    //DELEGATE
    weak var delegate:SearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialization()
        UIConfiguration()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Initialization -
    
    func initialization() {
        
        //TextField
        
    }
    
    func UIConfiguration () {
        
        
    }
    
    
    
    //MARK: - TextField =
    @IBAction func textFieldTextChanged(_ sender: Any) {
        
        if let text = (sender as! UITextField).text {
            
            delegate?.searchTableViewCellDidChangeText(cell: self, text: text);
        }
    }

    
}
