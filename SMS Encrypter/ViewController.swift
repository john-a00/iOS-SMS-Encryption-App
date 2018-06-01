//
//  ViewController.swift
//  SMS Encrypter
//
//  Created by Matt Nolan on 30/5/18.
//  Copyright © 2018 Matt Nolan. All rights reserved.
//

import UIKit
import RNCryptor

var smsBodyText = ""

class ViewController: UIViewController {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var outputText: UILabel!
    @IBOutlet weak var smsNumber: UITextField!
    @IBOutlet weak var smsBody: UITextView!
    @IBOutlet weak var sendViaSMS: UIButton!
    @IBOutlet weak var receiverNumber: UITextField!
    let messageComposer = MessageComposer()
    var passphrase: String = "SuperS3cretP@$$w0rd!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func encryptSend(_ sender: UIButton) {
        let inTxt: String = inputText.text!
        var encryptedMessage: String! = ""
        encryptedMessage = try! encryptText(message: inTxt, password: passphrase)
        outputText.text = encryptedMessage
        smsBodyText = encryptedMessage
        inputText.text = encryptedMessage
        sendViaSMS.isEnabled = true
    }
    
    @IBAction func editPhoneNumber(_ sender: UITextField) {
        smsBody.text = smsBodyText
    }
    
    @IBAction func decryptPress(_ sender: UIButton) {
        let inTxt: String = inputText.text!
        if inTxt.starts(with: "en5/"){
            let newMessage = inTxt.replacingOccurrences(of: "en5/", with: "")
            var decryptedMessage: String! = ""
            decryptedMessage = try! decryptText(message: newMessage, encryptionKey: passphrase)
            outputText.text = decryptedMessage
            smsBodyText = decryptedMessage
            inputText.text = decryptedMessage
            sendViaSMS.isEnabled = true
        }
    }
    
    @IBAction func sendSMS(_ sender: AnyObject) {
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(smsBody: smsBodyText, receiverNumber: receiverNumber.text!)
            
            // Present the configured MFMessageComposeViewController instance
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    
   /* func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }*/
    
    func encryptText(message: String, password: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: messageData, withPassword: password)
        let result = "en5/" + encryptedData.base64EncodedString()
        return result
    }
    
    func decryptText(message: String, encryptionKey: String) throws -> String {
        let encryptedData = Data.init(base64Encoded: message)
        let decryptedData = try RNCryptor.decrypt(data: encryptedData!, withPassword: encryptionKey)
        let decryptedMessage = String(data: decryptedData, encoding: .utf8)!
        return decryptedMessage
    }
    
}

