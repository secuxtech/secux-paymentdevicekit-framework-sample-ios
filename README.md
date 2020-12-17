# secux_paymentdevicekit

[![CI Status](https://img.shields.io/travis/maochuns/secux-paymentkit-v2.svg?style=flat)](https://travis-ci.org/maochuns/secux-paymentkit-v2)
[![Version](https://img.shields.io/cocoapods/v/secux-paymentdevicekit.svg?style=flat)](https://cocoapods.org/pods/secux-paymentdevicekit)
[![License](https://img.shields.io/cocoapods/l/secux-paymentkit-v2.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit-v2)
[![Platform](https://img.shields.io/cocoapods/p/secux-paymentkit-v2.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit-v2)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

### CocoaPods:

secux-paymentdevicekit is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'secux-paymentdevicekit'
```

### Carthage:

```
binary "https://maochuns.github.io/secux_paymentdevicekit.json" ~> 2.0.12
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


2. <b>Get device opeation ivKey</b>

Get the opeation ivKey from the payment device when payment device is in payment / promotion / refund / refill mode.

<span style="color:red">Note: Call the function in thread. You are allowed to cancel the payment after getting the ivKey.</span>

* <b>2.1 Get device opeation ivKey from device ID</b>

#### <u>Declaration</u>
```swift
    func doGetIVKey(devID:String) -> (SecuXPaymentPeripheralManagerError, String)
```

#### <u>Parameters</u>
```
    devID: Device ID, e.g. "811c00000016"
```
* <b>2.2 Get device opeation ivKey from device ID and opeation nonce</b>

This is recommended to get the ivKey when using P22. Operation nonce can garantee the payment correctness.

#### <u>Declaration</u>
```java
    func doGetIVKey(devID:String, nonce:[UInt8]) -> (SecuXPaymentPeripheralManagerError, 
                                                    String)
```

#### <u>Parameters</u>
```
    devID: Device ID, e.g. "811c00000016"
    nonce: Payment nonce from payment QR code, convert the nonce hex string to byte array

    Payment QR code sample:
    {"amount":"5", "coinType":"DCT:SPC", "nonce":"e956013c", 
    "deviceIDhash":"b0442888f1c9ddb5bb924382f44b0f025e0dc7cd"}
```

#### <u>Return value</u>
```
    SecuXPaymentPeripheralManagerError shows the operation result, if the result is  
    .OprationSuccess, the returned String contains device's ivKey, 
    otherwise String might contain an error message.  
```

#### <u>Error message</u>
```
    - Scan device failed!
    - No device coding key info.
    - Invalid payment QRCode! QRCode is timeout!
    - Device is not activated!
    - Set device timeout failed!
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

3. <b>Cancel operation</b>

Call the function after getting opeation ivKey, will cancel the opeation.

#### <u>Declaration</u>
```swift
    func requestDisconnect()
```

4. <b>Generate encrypted operation data</b>

Source code of the SecuXUtility.swift can be found in secux-paymentdevicekit-test

#### <u>Declaration</u>
```swift
    static func getEncryptMobilePaymentCommand(terminalId:String, 
                                                   amount:String, 
                                                    ivKey:String, 
                                                 cryptKey:String,
                                                 currency:String)->Data?
```

#### <u>Parameters</u>
```
    terminalId:  An ID string used in device activation 
    cryptKey:    A key string used in device activation
    ivKey:       Device payment ivKey from doGetIVKey function
    amount:      Payment amount
    currency:    Payment currency. For FW v1.0, currency is "SPC"; 
                 For FW v2.0, currency is "DCT:SPC"
```

#### <u>Return value</u>
```
    Ecrypted payment data.
```

#### <u>Sample</u>
```swift
    let payData = SecuXUtility.getEncryptMobilePaymentCommand(terminalId: "gkn3p0ec", 
                                                amount: "200", 
                                                ivKey: ivkey, 
                                                cryptKey: "asz2gorm5bxh5nc5ecjjsqqstgnlsxsj")
```

5. <b>Confirm operation</b>

Send the encrypted operation data to the device to confirm the opearation.

<span style="color:red">Note: call the function in thread.</span>

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
```

#### <u>Sample</u>
```swift
    DispatchQueue.global().async {
        let payData = SecuXUtility.getEncryptMobilePaymentCommand(terminalId: "gkn3p0ec",      
                                            amount: "2", 
                                            ivKey: ivkey, 
                                            cryptKey: "asz2gorm5bxh5nc5ecjjsqqstgnlsxsj")
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

secux_paymentdevicekit is available under the MIT license. 

