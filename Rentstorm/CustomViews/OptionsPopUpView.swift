//
//  OptionsPopUpView.swift
//  Venner
//
//  Created by Joaquin Pereira on 2/22/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit


class PopUpConfirmation: UIView, UITableViewDelegate, UITableViewDataSource {
    
    //

    
    var optionBlock = {(option: Int) -> Void in }
    
    //
    @IBOutlet var mainView: UIView!
    
    
    init(frame: CGRect, rate:Rate) {
        
        super.init(frame:frame);
        initialization(object);
        UIConfiguration();
        
    }
    
    convenience init(object:PFObject) {
        
        self.init(frame:UIScreen.main.bounds.width, rate:Rate);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Initialization -
    
    func initialization(_ rate:Rate) {
        
        //Owner
        Bundle.main.loadNibNamed("PopUpConfirmation", owner: self, options: nil);
        
        
        //Object
        //self.object = object;
        
        //MainView
        mainView.frame = CGRect.init(x: 5, y: self.frame.size.height, width: frame.size.width - CGFloat(OPTION_MARGIN), height: mainViewHeight());
        addSubview(mainView);
        
        //Init
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        //UI
        self.alpha = 0;
        
        //Register class
        let cellNib = UINib.init(nibName: "OptionTableViewCell", bundle: nil);
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell");
        
        //Create touchView
        let touchView = UIView.init(frame: self.bounds);
        touchView.backgroundColor = UIColor.clear;
        self.addSubview(touchView);
        
        //Keep mainView at front
        self.bringSubview(toFront: self.mainView);
        
        //Add gesture
        let backgroundTouchGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.hideView));
        touchView.addGestureRecognizer(backgroundTouchGesture);
    }
    
    func UIConfiguration() {
        
        //Owner
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4);
        
        //MainView
        self.mainView.layer.cornerRadius = 10;
        
        //TableView
        self.tableView.hideEmptyCells();
    }
    
    
    //MARK: - TableView Delegate|Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            return 1;
        }
        
        return numberOfOptions();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(OPTION_CELL_HEIGHT);//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InfoTableViewCell;
        
        cell.lbl_text.text = optionWithIndexPath(indexPath: indexPath);
        cell.img_image.image = imageWithName(name: optionWithIndexPath(indexPath: indexPath));
        
        //UI
        if indexPath.section == 1 {
            
            cell.boldText(); //Cancel
            
        }else if indexPath.section == 0 {
            
            if indexPath.row == numberOfOptions() - 1 {
                
                //Text
                cell.changeTextColor(#colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1));
                
                //Tint image
                cell.img_image.tintColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1);
            
            }else{
                
                //Regular
                cell.changeTextColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1));
                
            }
            
            cell.regularText();
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            self.optionBlock(optionSelected(name:optionWithIndexPath(indexPath: indexPath)));
        }
        
        if indexPath.section == 1 {
            
            hideView();
        }
    }
    
    //MARK: - TableView Methods
    
    func optionWithIndexPath(indexPath:IndexPath) -> String{
        
        if object?.parseClassName == "Post" || object?.parseClassName == "Comment" || object?.parseClassName == "Picture" {
            
            if indexPath.section == 0 {
                
                if PostModel.isCurrentUserPostOwner(object) {
                    
                    switch indexPath.row {
                        
                    case 0:
                        return EDIT;
                        
                    case 1:
                        return SHARE;
                        
                    case 2:
                        return DELETE;
                        
                    default:
                        return "";
                    }
                    
                }else{
                    
                    switch indexPath.row {
                        
                    case 0:
                        return SHARE;
                        
                    case 1:
                        return REPORT;
                        
                    default:
                        return "";
                    }
                }
                
            }
            
            if indexPath.section == 1 {
                
                return CANCEL;
            }
        }
        
        return "";
    }
    
    func imageWithName(name:String) -> UIImage {
        
        if object?.parseClassName == "Post" || object?.parseClassName == "Comment" || object?.parseClassName == "Picture" {
            
            
            if name == EDIT {
                
                return UIImage.init(named: "Edit_70x?")!;
            }
            
            if name == SHARE {
                
                return UIImage.init(named: "Share_70x?")!;
            }
            
            if name == DELETE {
                
                return UIImage.init(named: "Delete_70x?")!;
            }
            
            if name == REPORT {
                
                let originalImage = UIImage.init(named: "Report_70x?")!
                let tintableImage = originalImage.withRenderingMode(.alwaysTemplate);
                
                return tintableImage;
            }
            
            if name == CANCEL {
                
                return UIImage.init(named: "Cancel_70x?")!;
            }
            
        }
        
        return UIImage();
    }
    
    
    //MARK: - Completion Blocks
    
    @objc func optionSelected(completion: @escaping (Int) -> Void) {
        
        self.optionBlock = completion;
    }
    
    
    //MARK: - UI -
    
    func showView() {
        
        //MainView rect

        let y = frame.size.height - CGFloat(OPTION_MARGIN) - mainViewHeight();
        
        //Animate
        UIView.animate(withDuration: 0.1, animations: {
            
            self.alpha = 1;
            
        }) { (done) in
            
            UIView.animate(withDuration: 0.2) {
                
                self.mainView.frame = CGRect.init(x: 5, y: y, width: self.frame.size.width - CGFloat(self.OPTION_MARGIN), height: self.mainViewHeight());
            };
        }

    }
    
    func hideView() {
        
        //Animate
        UIView.animate(withDuration: 0.2, animations: {
            
            self.mainView.frame = CGRect.init(x: 5, y: self.frame.size.height, width: self.frame.size.width - CGFloat(self.OPTION_MARGIN), height: self.mainViewHeight());
            
        }) { (done) in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.alpha = 0;
                
            }, completion: { (done) in
                
                self.removeFromSuperview();
            })
        };
    }
    
    //MARK: - Native Methods -
    
    func numberOfOptions() -> Int{
        
        if object?.parseClassName == "Post" || object?.parseClassName == "Comment" || object?.parseClassName == "Picture" {
            
            if PostModel.isCurrentUserPostOwner(object) {
                
                return 3; //Edit, Share, Delete
                
            }else{
                
                return 2; // Share, Report
            }
        }
        
        return 0;
    }
    
    func optionSelected(name:String) -> Int{
        
        if object?.parseClassName == "Post" || object?.parseClassName == "Comment" || object?.parseClassName == "Picture" {
            
            
            if name == EDIT {
                
                return OptionType.Edit.rawValue;
            }
            
            if name == SHARE {
                
                return OptionType.Share.rawValue;
            }
            
            if name == DELETE {
                
                return OptionType.Delete.rawValue;
            }
            
            if name == REPORT {
                
                return OptionType.Report.rawValue;
            }
            
            if name == CANCEL {
                
                return OptionType.Cancel.rawValue;
            }
            
        }
        
        return OptionType.Cancel.rawValue;
    }
    
    func mainViewHeight() -> CGFloat {
        
        let height = (numberOfOptions() * OPTION_CELL_HEIGHT) + OPTION_CELL_HEIGHT; //options + cancel
        
        return CGFloat(height);
    }

}
