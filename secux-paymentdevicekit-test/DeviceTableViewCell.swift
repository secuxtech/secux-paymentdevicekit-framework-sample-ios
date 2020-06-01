//
//  DeviceTableViewCell.swift
//  secux-paymentdevicekit-test
//
//  Created by Maochun Sun on 2020/4/29.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit
import secux_paymentdevicekit

public extension UITableViewCell {
    /// Generated cell identifier derived from class name
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

class DeviceTableViewCell: UITableViewCell {
    
    lazy var bkView: UIView = {
        let bkview = UIView()
        bkview.translatesAutoresizingMaskIntoConstraints = false
        bkview.backgroundColor = .white
        
        bkview.layer.cornerRadius = 10
        /*
        bkview.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        bkview.layer.shadowOffset = CGSize(width: 1, height: 1)
        bkview.layer.shadowOpacity = 0.2
        bkview.layer.shadowRadius = 15
        */
        bkview.layer.shadowColor = UIColor.darkGray.cgColor
        //bkview.layer.shadowPath = UIBezierPath(roundedRect: bkview.bounds, cornerRadius: 10).cgPath
        bkview.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        bkview.layer.shadowOpacity = 0.4
        bkview.layer.shadowRadius = 3.0
        
        //bkview.layer.borderColor = UIColor(red: 0.62, green: 0.62, blue: 0.62,alpha:1).cgColor
        //bkview.layer.borderWidth = 2
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        //bkview.addGestureRecognizer(tap)
      
        
        self.contentView.addSubview(bkview)
        
        NSLayoutConstraint.activate([
            
            bkview.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
            bkview.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
            bkview.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6),
            bkview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6)
            
        ])
        
        return bkview
    }()
    
    lazy var itemNameLabel : UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10" //"\(row+1)"

        //label.font = UIFont.preferredFont(forTextStyle: .headline)
        //label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.init(name: "Arial-Bold", size: 16)
        label.textColor = UIColor(red: 0x70/255, green: 0x70/255, blue: 0x70/255, alpha: 1)
        label.textAlignment = NSTextAlignment.left

        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()


        self.contentView.addSubview(label)
        return label
    }()

    lazy var itemValLabel : UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""

        label.font = UIFont.init(name: "Arial", size: 16)
        label.textColor = UIColor(red: 0x70/255, green: 0x70/255, blue: 0x70/255, alpha: 1)
        label.textAlignment = NSTextAlignment.right

        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()

        self.contentView.addSubview(label)

        return label
    }()
    
    @objc func onTapped(flag:Bool){
        //if !cellSelected{
        if flag{
            self.bkView.backgroundColor = UIColor(red: 0xFF/0xFF, green: 0xF9/0xFF, blue: 0xE9/0xFF, alpha: 1.0)
            self.bkView.layer.borderColor = UIColor(red: 0xDF/0xFF, green: 0xB4/0xFF, blue: 0x45/0xFF, alpha: 1.0).cgColor
            self.bkView.layer.borderWidth = 2
            self.bkView.layer.setNeedsDisplay()
            
        }else{
            self.bkView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
            self.bkView.layer.borderColor = UIColor.lightGray.cgColor
            self.bkView.layer.borderWidth = 0
            self.bkView.layer.setNeedsDisplay()
        }
        
        //cellSelected = !cellSelected
    }
    
    var theDevice : SecuXBLEDev?
    var cellSelected = false
    
    func setup(device: SecuXBLEDev){
        
        self.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        var _ = self.bkView
      

        self.theDevice = device
        //self.theAccount?.formatedBalance.addObserver({ (value) in
        //   self.itemValLabel.text = "\(account.formatedBalance.value) \(account.type.rawValue)"
        //   self.itemBalanceLabel.text = "$" + String(account.usdBalance.roundToDecimal(2))
        //})
       

        NSLayoutConstraint.activate([
            
            
            self.itemNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            self.itemNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.itemNameLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 1/2, constant: -10),
            
            
            self.itemValLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
            self.itemValLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        if let devID = device.paymentPeripheral?.uniqueID{
            self.itemNameLabel.text = devID
        }else{
            self.itemNameLabel.text = "No DevID"
        }
        self.itemValLabel.text = "\(device.RSSI)"
        
        self.bkView.layer.borderColor = UIColor.lightGray.cgColor
        self.bkView.layer.borderWidth = 0
        self.bkView.layer.setNeedsDisplay()
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
}
