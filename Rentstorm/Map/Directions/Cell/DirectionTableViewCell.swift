//
//  DirectionTableViewCell.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/19/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import MapKit

class DirectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_image: UIImageView!
    @IBOutlet weak var lbl_text: UILabel!
    
    var step:MKRouteStep!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //MARK: - Info -
    
    func loadInformation() {
        
        //Determine the appropiate arrow
        self.img_image.image = imageWithText(text: self.step.instructions)
        
        //Text
        self.lbl_text.text = self.step.instructions;
        
        
    }
    
    
    //MARK: - Helpers -
    
    func imageWithText(text:String) -> UIImage {
        
        //This method is a basic aprox to a real MapsApp
        
        let words = text.components(separatedBy:" ");
        
        for word in words {
            
            let lowercasedWord = word.lowercased()
            
            if lowercasedWord == "left" {
                
                return #imageLiteral(resourceName: "LeftArrow")
            }
            
            if lowercasedWord == "right" {
                
                return #imageLiteral(resourceName: "RightArrow")
            }
        }
        
        return #imageLiteral(resourceName: "StraightArrow");
        
    }
    
}
