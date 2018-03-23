//
//  TableViewHeader.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/15/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

class TableViewHeader: UIView {

    //Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    
    init(frame: CGRect, title:String) {
        
        super.init(frame:frame)
        
        Bundle.main.loadNibNamed("TableViewHeader", owner: self, options: nil);
        self.mainView.frame = self.bounds;
        addSubview(self.mainView);
        
        self.lbl_title.text = title;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
