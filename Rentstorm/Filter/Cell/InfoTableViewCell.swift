//
//  InfoTableViewCell.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/23/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var img_image: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_subtitle: UILabel!
    @IBOutlet weak var lbl_extraSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
