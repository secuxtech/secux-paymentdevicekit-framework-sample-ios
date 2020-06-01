//
//  ViewController.swift
//  secux-paymentdevicekit-test
//
//  Created by Maochun Sun on 2020/4/23.
//  Copyright © 2020 SecuX. All rights reserved.
//

import UIKit
import secux_paymentdevicekit
import CoreBluetooth

class ViewController: BaseViewController {
    
    
    lazy var rescanButton:  UIRoundedButtonWithGradientAndShadow = {
        
        let btn = UIRoundedButtonWithGradientAndShadow(gradientColors: [UIColor(red: 0xEB/0xFF, green: 0xCB/0xFF, blue: 0x56/0xFF, alpha: 1), UIColor(red: 0xEB/0xFF, green: 0xCB/0xFF, blue: 0x56/0xFF, alpha: 1)])
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 22)
        btn.setTitleColor(UIColor(red: 0x1F/0xFF, green: 0x20/0xFF, blue: 0x20/0xFF, alpha: 1), for: .normal)
        btn.setTitleColor(UIColor.white, for: .disabled)
        btn.setTitle(NSLocalizedString("Rescan", comment: ""), for: .normal)
        //btn.setBackgroundColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for:.disabled)
        btn.addTarget(self, action: #selector(rescanAction), for: .touchUpInside)
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 0.3
        
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            
            btn.bottomAnchor.constraint(equalTo: self.paymentButton.topAnchor, constant: -20),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            btn.heightAnchor.constraint(equalToConstant: 46)
            
        ])
       
        return btn
    }()
    
    lazy var paymentButton:  UIRoundedButtonWithGradientAndShadow = {
        
        let btn = UIRoundedButtonWithGradientAndShadow(gradientColors: [UIColor(red: 0xEB/0xFF, green: 0xCB/0xFF, blue: 0x56/0xFF, alpha: 1), UIColor(red: 0xEB/0xFF, green: 0xCB/0xFF, blue: 0x56/0xFF, alpha: 1)])
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 22)
        btn.setTitleColor(UIColor(red: 0x1F/0xFF, green: 0x20/0xFF, blue: 0x20/0xFF, alpha: 1), for: .normal)
        btn.setTitleColor(UIColor.white, for: .disabled)
        btn.setTitle(NSLocalizedString("Pay", comment: ""), for: .normal)
        //btn.setBackgroundColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), for:.disabled)
        btn.addTarget(self, action: #selector(paymentAction), for: .touchUpInside)
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 2
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 0.3
        
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            
            btn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -26),
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            btn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            btn.heightAnchor.constraint(equalToConstant: 46)
            
        ])
       
        return btn
    }()
    
    
    lazy var theTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        
        self.view.addSubview(tableView)

       
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.rescanButton.topAnchor, constant: -30)
            
        ])
        
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: DeviceTableViewCell.cellIdentifier())
        
        return tableView
    }()
    
    var peripheralManager = SecuXPaymentPeripheralManager(scanTimeout: 5, connTimeout: 30, checkRSSI: -80)
    let terminalID = "gkn3p0ec"
    let paymentKey = "asz2gorm5bxh5nc5ecjjsqqstgnlsxsj"
    
    var theSelectedCell : DeviceTableViewCell?
    var deviceList = [SecuXBLEDev]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        SecuXBLEManager.shared.delegate = self
        SecuXBLEManager.shared.scanDevice(enable: true)
        
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)

        let _ = self.rescanButton
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SecuXBLEManager.shared.scanForPeripherals(false)
    }

    
    @objc func rescanAction(){
        SecuXBLEManager.shared.scanDevice(enable: false)
        self.deviceList.removeAll()
        self.theTableView.reloadData()
        self.theSelectedCell = nil
        SecuXBLEManager.shared.delegate = self
        SecuXBLEManager.shared.scanDevice(enable: true)
    }
    
    
    func doPayment(dev: SecuXBLEDev){
        guard let paymentPeripheral = dev.paymentPeripheral else{
            logw("Invalid device")
            return
        }
        
        let (ret, ivkey) = self.peripheralManager.doGetIVKey(devID: paymentPeripheral.uniqueID)
        print("\(ret) \(ivkey)")
        if ret == .OprationSuccess{
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Please confirm the payment", message: "", preferredStyle: UIAlertController.Style.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) -> Void in
                    //self.peripheralManager.requestDisconnect()
                })
                
                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: {
                    (action: UIAlertAction!) -> Void in
                      
                        DispatchQueue.global().async {
                            let payData = SecuXUtility.getEncryptMobilePaymentCommand(terminalId: self.terminalID, amount: "2", ivKey: ivkey, cryptKey: self.paymentKey)
                            let (payret, error) = self.peripheralManager.doPaymentVerification(encPaymentData: payData!)
                            
                            if payret == .OprationSuccess{
                                self.showMessageInMainThread(title: "Payment successful!", message: "")
                                
                            }else{
                                self.showMessageInMainThread(title: "Payment failed!", message: "Error: \(error)")
                            }
                        }
                        
                })
                
                
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
        }else{
        
            self.showMessageInMainThread(title: "Payment failed!", message: "Get ivkey failed! Error: \(ivkey)")
        }
            

    }
    
    @objc func paymentAction(){
        
        guard let dev = self.theSelectedCell?.theDevice else{
            self.showMessage(title: "Please select a device", message: "")
            return
        }
        
        guard let _ = dev.paymentPeripheral else{
            logw("Invalid device")
            return
        }
        
        SecuXBLEManager.shared.scanDevice(enable: false)
        SecuXBLEManager.shared.delegate = nil
        self.showProgress(info: "In process ...")
        
        DispatchQueue.global(qos: .default).async {
            
            let _ = self.doPayment(dev: dev)
            self.hideProgress()
        }
    }
}


extension ViewController: BLEDevControllerDelegate{
    func updateConnDevStatus(status: Int) {
        
    }
    
    func enableBLESetting() {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "Bluetooth is off",
                                          message:"Please turn on your bluetooth",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Setting",
                                          style: .default,
                                          handler: {
                                            
                                            (action) in
                                            if action.style == .default{
                                                
                                                if let url = URL(string:UIApplication.openSettingsURLString)
                                                {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                                
                                            }
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .default,
                                          handler: nil))
            
            
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    func newBLEDevice(newDev:SecuXBLEDev){
        self.deviceList.append(newDev)
        DispatchQueue.main.async {
            self.theTableView.reloadData()
        }
        
    }
    
    func updateBLEDevice(dev:SecuXBLEDev){
        for i in 0..<self.deviceList.count{
            let device = deviceList[i]
            if device.isEqual(dev){
                //DispatchQueue.main.async {
                //    self.theTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
                //}
                return
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.deviceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceTableViewCell.cellIdentifier(), for:indexPath)
        cell.selectionStyle = .none
        if let commonCell = cell as? DeviceTableViewCell{
            let device = self.deviceList[indexPath.row]
            commonCell.setup(device: device)
            commonCell.onTapped(flag: false)
            
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        self.theSelectedCell?.onTapped(flag: false)
        
        if let cell = tableView.cellForRow(at: indexPath)as? DeviceTableViewCell{
            cell.onTapped(flag:true)
            self.theSelectedCell = cell
        }
        
    }
    
}
