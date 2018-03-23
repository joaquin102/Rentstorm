//
//  ButtonTableViewCell.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/16/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    
    func buttonTableViewCellDidTapped(cell:ButtonTableViewCell);
    
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_button: UIButton!
    @IBOutlet weak var lbl_text: UILabel!
    
    weak var delegate:ButtonTableViewCellDelegate?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //BUtton UI
        btn_button.layer.borderWidth = 2;
        btn_button.layer.borderColor = #colorLiteral(red: 0.8818888068, green: 0.3359293342, blue: 0.2336356044, alpha: 1)
        btn_button.layer.cornerRadius = btn_button.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        delegate?.buttonTableViewCellDidTapped(cell: self);
    }
    
}
