//
//  PopUpConfirmation.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/18/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FLAnimatedImage

class PopUpConfirmation: UIView {
    
    let MARGIN = 10;
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var viewActivityIndicatorContainer: UIView!
    @IBOutlet weak var viewActivityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var lbl_carName: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var img_company: UIImageView!
    @IBOutlet weak var img_car: UIImageView!
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var lbl_text: UILabel!
    
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var img_confirmation: FLAnimatedImageView!
    
    var confirmationBlock: ((_ successful:Bool) -> Void)?
    
    init(frame: CGRect, rate:Rate) {
        
        super.init(frame:frame);
        initialization(rate);
        UIConfiguration();
        
    }
    
    convenience init(rate:Rate) {
        
        self.init(frame:UIScreen.main.bounds, rate:rate);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Initialization -
    
    func initialization(_ rate:Rate) {
        
        //Owner
        Bundle.main.loadNibNamed("PopUpConfirmation", owner: self, options: nil);
        
        
        //MainView
        mainView.frame = CGRect.init(x: 5, y: self.frame.size.height, width: frame.size.width - CGFloat(MARGIN), height: mainViewHeight());
        addSubview(mainView);

        //UI
        self.alpha = 0;
        
        //Values

        img_company.image = UIImage.init(named: rate.company!);
        lbl_address.text = rate.branchAddress;
        
        //Name
        lbl_carName.text = rate.suggestedName;
        
        //Rate Price
        lbl_price.text = "\(rate.currency!)\(rate.totalString!)";
        
        //Image
        img_car.image = UIImage.init(named: rate.category!.rawValue);
        
        //Dates
        self.lbl_text.text = dateString(date: rate.startDate!) + " - " + dateString(date: rate.endDate!);

        
        //Create touchView
        let touchView = UIView.init(frame: self.bounds);
        touchView.backgroundColor = UIColor.clear;
        self.addSubview(touchView);
        
        //Keep mainView at front
        self.bringSubview(toFront: self.mainView);
        
        //Add gesture
        let backgroundTouchGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.hidePopUp));
        touchView.addGestureRecognizer(backgroundTouchGesture);
    }
    
    func UIConfiguration() {
        
        //Owner
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4);
        
        //Init
        self.viewActivityIndicatorContainer.alpha = 0;
        
        //MainView
        self.mainView.layer.cornerRadius = 10;
        
        //Button
        btn_confirm.layer.cornerRadius = btn_confirm.frame.height / 2
        
    }
    
    
    //MARK: - Public blocks
    
    func confirmation(block:@escaping (_ successful:Bool) -> Void) {
        
        self.confirmationBlock = block;
    }
    
    
    //MARK: - UI Methods -
    
    func showPopUp() {
        
        //MainView rect
        
        let y = frame.size.height - CGFloat(MARGIN) - mainViewHeight();
        
        //Animate
        UIView.animate(withDuration: 0.1, animations: {
            
            self.alpha = 1;
            
        }) { (done) in
            
            UIView.animate(withDuration: 0.2) {
                
                self.mainView.frame = CGRect.init(x: 5, y: y, width: self.frame.size.width - CGFloat(self.MARGIN), height: self.mainViewHeight());
            };
        }
    }
    
    @objc func hidePopUp() {
        
        //Animate
        UIView.animate(withDuration: 0.2, animations: {
            
            self.mainView.frame = CGRect.init(x: 5, y: self.frame.size.height, width: self.frame.size.width - CGFloat(self.MARGIN), height: self.mainViewHeight());
            
        }) { (done) in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.alpha = 0;
                
            }, completion: { (done) in
                
                self.removeFromSuperview();
            })
        };
    }
    
    func showMakingReservationUI() {
        
        //Show activity
        UIView.animate(withDuration: 0.2) {
            
            self.viewActivityIndicatorContainer.alpha = 1;
        }
        
        self.viewActivityIndicator.startAnimating();
        
    }
    
    func showReservationConfirmed() {
        
        UIView.animate(withDuration: 0.2
            , animations: {
                
                self.viewActivityIndicator.alpha = 0;
                self.img_confirmation.alpha = 1;
                
        }) { (done) in
        
            do {
                
                try self.img_confirmation.animatedImage = FLAnimatedImage(animatedGIFData: Data(contentsOf: Bundle.main.url(forResource:"check", withExtension: "gif")!))
                
            } catch {
                
                print("error getting gif");
            }
        }
    }
    
    //MARK: - Helpers -
    
    func mainViewHeight() -> CGFloat {
        
        return UIScreen.main.bounds.height * 0.5;
    }
    
    
    func dateString(date:Date) -> String {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMM dd/yyyy"
        
        // Apply date format
        let string: String = dateFormatter.string(from: date)
        
        return string;
    }
    
    //mARK: - Actions -
    
    @IBAction func confirmRental(_ sender: Any) {
        
        //Change UI
        showMakingReservationUI();
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.showReservationConfirmed();
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.88, execute: {
                
                self.confirmationBlock!(true);
                
                self.hidePopUp()
            })
        }
    }
    
    @IBAction func cancelRental(_ sender: Any) {
        
        hidePopUp();
    }
    
    
}
