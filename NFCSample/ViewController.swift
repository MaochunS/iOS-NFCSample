//
//  ViewController.swift
//  NFCSample
//
//  Created by maochun on 2020/11/18.
//

import UIKit

import CoreNFC

class ViewController: UIViewController {

    lazy var theButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Detect NFC", for: .normal)
        button.addTarget(self, action: #selector(detectNFCAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
        ])
        
        return button
    }()
    
    var session: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let _ = self.theButton
    }
    
    
    @objc func detectNFCAction(){
        
        if NFCNDEFReaderSession.readingAvailable {
            session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
            session?.begin()
        }else{
            self.showMessage(title: "Your phone DOES NOT support NFC!", message: "")
        }
        
        
    }
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: NFCNDEFReaderSessionDelegate{
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        var nfcString = ""
        for message in messages {
            
            for record in message.records {
                if let string = String(data: record.payload, encoding: .utf8) {
                    print(string)
                    
                    
                    var type = "Unknown"
                    
                    if let typeStr = String(data: record.type, encoding: .utf8){
                        print("Type: \(typeStr)")
                        
                        
                        if typeStr == "U"{
                            type = "URI"
                        }else if typeStr == "T"{
                            type = "Text"
                        }else if typeStr == "Sp"{
                            type = "Smart Poster"
                        }
                    }
                    
                    nfcString += "Type: \(type)  Data: \(string)\n\n"
                    
                }

                print("Type name format: \(record.typeNameFormat)")
                print("Payload: \(record.payload.count)")
                
            }

        }
        
        session.invalidate()
        
        self.showMessage(title: nfcString, message: "")
    }
    
    
}
