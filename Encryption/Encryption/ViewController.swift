//
//  ViewController.swift
//  Encryption
//
//
import CryptoKit
import UIKit

class ViewController: UIViewController {
    
    let data = Data("hello".utf8)
    override func viewDidLoad() {
        super.viewDidLoad()
        encrypt()
    }
    func encrypt() {
        do {
            let key256 = SymmetricKey(size: .bits256)
            let serializedSymmetricKey = key256.serialize()

            guard let deserializedSymmetricKey = SymmetricKey(base64EncodedString: serializedSymmetricKey) else {
                print("deserializedSymmetricKey was nil.")
                return
            }
                            
            let encryptedData = try! ChaChaPoly.seal(data, using: key256).combined
            let sealedBox = try! ChaChaPoly.SealedBox(combined: encryptedData)
            let decryptedData = try! ChaChaPoly.open(sealedBox, using: deserializedSymmetricKey)
            print(String(decoding: encryptedData, as: UTF8.self))
            print(String(decoding: decryptedData, as: UTF8.self))
        }
    }
}

extension SymmetricKey {
    init?(base64EncodedString: String) {
        guard let data = Data(base64Encoded: base64EncodedString) else {
            return nil
        }

        self.init(data: data)
    }
    func serialize() -> String {
        return self.withUnsafeBytes { body in
            Data(body).base64EncodedString()
        }
    }
}

