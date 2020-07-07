# secux_paymentdevicekit

[![CI Status](https://img.shields.io/travis/maochuns/secux-paymentkit-v2.svg?style=flat)](https://travis-ci.org/maochuns/secux-paymentkit-v2)
[![Version](https://img.shields.io/cocoapods/v/secux-paymentkit-v2.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit-v2)
[![License](https://img.shields.io/cocoapods/l/secux-paymentkit-v2.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit-v2)
[![Platform](https://img.shields.io/cocoapods/p/secux-paymentkit-v2.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit-v2)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

secux-paymentdevicekit is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'secux-paymentdevicekit'
```

### Add bluetooth privacy permissions in the plist

![Screenshot](Readme_PlistImg.png)

### Import the module

```swift 
    import secux_paymentdevicekit
```

## Usage

1. <b>SecuXPaymentPeripheralManager initialization</b>
#### <u>Parameters</u>
```
    scanTimeout: Timeout in seconds for device scan
    connTimeout: Timeout in seconds for connection with device
    checkRSSI:   Scan device within the RSSI value
```

#### <u>Sample</u>
```swift
    var peripheralManager = SecuXPaymentPeripheralManager(scanTimeout: 5, 
                                                          connTimeout: 30, 
                                                          checkRSSI: -80)
```


2. <b>Get device payment ivKey</b>

Get the payment ivKey from the payment device.

#### <u>Declaration</u>
```swift
    func doGetIVKey(devID:String) -> (SecuXPaymentPeripheralManagerError, String)
```

#### <u>Parameters</u>
```
    devID: Device ID, e.g. "811c00000016"
```

#### <u>Return value</u>
```
    SecuXPaymentPeripheralManagerError shows the operation result, if the result is  
    .OprationSuccess, the returned String contains device's ivKey, 
    otherwise String might contain an error message.  

    Note: Call the function in thread. You are allowed to cancel the payment after getting the ivKey. 
```

#### <u>Sample</u>
```swift
    let (ret, ivkey) = self.peripheralManager.doGetIVKey(devID: "811c00000016")
    print("\(ret) \(ivkey)")
    if ret == .OprationSuccess{
        ...

    }else{
        
        self.showMessageInMainThread(title: "Payment failed!", 
                                   message: "Get ivkey failed! Error: \(ivkey)")
    }
```

3. <b>Cancel Payment</b>

Call the function after getting payment ivKey, will cancel the payment.

#### <u>Declaration</u>
```swift
    func requestDisconnect()
```

4. <b>Generate encrypted payment data</b>

#### <u>Declaration</u>
```swift
    static func getEncryptMobilePaymentCommand(terminalId:String, 
                                                   amount:String, 
                                                    ivKey:String, 
                                                 cryptKey:String)->Data?
```

#### <u>Parameters</u>
```
    terminalId:  An ID string used in device activation 
    cryptKey:    A key string used in device activation
    ivKey:       Device payment ivKey from doGetIVKey function
    amount:      Payment amount
```

#### <u>Return value</u>
```
    Ecrypted payment data.
```

#### <u>Sample</u>
```swift
    let payData = SecuXUtility.getEncryptMobilePaymentCommand(terminalId: "gkn3p0ec", 
                                                                  amount: "200", 
                                                                  ivKey: ivkey, cryptKey: pKey)
```

5. <b>Do payment</b>

Send the encrypted payment data to the device to confirm the payment.
#### <u>Declaration</u>
```swift
    func doPaymentVerification(encPaymentData:Data) ->  
                                            (SecuXPaymentPeripheralManagerError, String)
```

#### <u>Parameters</u>
```
    encPaymentData: The encrypted payment data.
```

#### <u>Return value</u>
```
    SecuXPaymentPeripheralManagerError shows the operation result, if the result is not 
    .OprationSuccess, the returned String might contain an error message.  

    Note: call the function in thread.
```

#### <u>Sample</u>
```swift
    DispatchQueue.global().async {
        let payData = SecuXUtility.getEncryptMobilePaymentCommand(terminalId: self.terminalID, amount: "2", ivKey: ivkey, cryptKey: self.paymentKey)
        let (payret, error) = self.peripheralManager.doPaymentVerification(encPaymentData: payData!)
        
        if payret == .OprationSuccess{
            self.showMessageInMainThread(title: "Payment successful!", message: "")
            
        }else{
            self.showMessageInMainThread(title: "Payment failed!", message: "Error: \(error)")
        }
    }
```

## Author

maochuns, maochunsun@secuxtech.com

## License

secux_paymentdevicekit is available under the MIT license. See the LICENSE file for more info.

