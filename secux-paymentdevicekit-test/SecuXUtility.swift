//
//  SecuXUtility.swift
//  secux-paymentdevicekit
//
//  Created by Maochun Sun on 2020/4/24.
//  Copyright © 2020 SecuX. All rights reserved.
//

import Foundation


extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

public class SecuXUtility {

    static func byteArrayToHexString(byteArr:[UInt8]) -> String{
        let data = Data(byteArr)
        return data.hexEncodedString()
    }
    
    public static func getEncryptMobilePaymentCommand(terminalId:String, amount:String, ivKey:String, cryptKey:String)->Data?{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let transactionTime = formatter.string(from: date)
        formatter.dateFormat = "mmss"

        // transactionId is 16 bytes. it's testing data in sample code.
        let lastFourDigit = formatter.string(from: date)
        let transactionId = "P12345678912" + "\(lastFourDigit)"

        // concate transaction data
        let decryptedTransaction = "\(transactionTime),\(transactionId),\(terminalId),\(amount),DCT:SPC"

        // Simulate Server AES CBC encryption in App, please transfer these code to your server
        let plaintext: NSData = decryptedTransaction.data(using: .utf8)! as NSData
        if let encryptKey = cryptKey.data(using: .utf8), let iv = ivKey.data(using:.utf8){
            var encrypted = Data()
            let encryptor = Engine(operation: .encrypt, key: encryptKey, iv: iv)
            encrypted.append(encryptor.update(withData: plaintext as Data))
            encrypted.append(encryptor.finalData())
            return encrypted
        }
        
        return nil
    }
    
    
    
}
