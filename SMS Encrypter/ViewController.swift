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
    
    // Set Variables and outlet links to UI Elements
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
    
    // This function is the function to run when the user selects the "Encrypt" Button
    @IBAction func encryptSend(_ sender: UIButton) {
        let inTxt: String = inputText.text!
        var encryptedMessage: String! = ""
        // Try to run the excryptText method taking 2 inputs: String to encrypt, String to use as a password for the encryption.
        encryptedMessage = try! encryptText(message: inTxt, password: passphrase)
        outputText.text = encryptedMessage
        
        // Set the global variable smsBodyText to the encrypted message
        // Then set the user input box to display the encrypted message
        // Lastly encable the share via sms button for the user to sahre the encrypted code
        smsBodyText = encryptedMessage
        inputText.text = encryptedMessage
        sendViaSMS.isEnabled = true
    }
    
    @IBAction func editPhoneNumber(_ sender: UITextField) {
        // When the user starts to enter the mobile phone number, update the instructions to equal the encrypted text
        smsBody.text = smsBodyText
    }
    
    @IBAction func decryptPress(_ sender: UIButton) {
        let inTxt: String = inputText.text!
        // Check if the string to decrypt matches the algorythm to avoid error
        if inTxt.starts(with: "en5/"){
            // Remove the opening salt
            let newMessage = inTxt.replacingOccurrences(of: "en5/", with: "")
            var decryptedMessage: String! = ""
            // Try to decrypt the message using 2 inputs: String to decrpyt, password used to encrpyt the message with
            decryptedMessage = try! decryptText(message: newMessage, encryptionKey: passphrase)
            outputText.text = decryptedMessage
            smsBodyText = decryptedMessage
            inputText.text = decryptedMessage
            
            // Disable the share via sms button because sending the message as plain text is a flaw in the design of the app
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
    
    func encryptText(message: String, password: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        // Convert the message to encrypted data using the customised RNCryptor library found online
        let encryptedData = RNCryptor.encrypt(data: messageData, withPassword: password)
        // Add the en5/ salt as well and then convert the encrypted data to a string so it con be returned and displayed
        let result = "en5/" + encryptedData.base64EncodedString()
        return result
    }
    
    func decryptText(message: String, encryptionKey: String) throws -> String {
        let encryptedData = Data.init(base64Encoded: message)
        // Decrypt the data using the custom RNCryptor found online
        let decryptedData = try RNCryptor.decrypt(data: encryptedData!, withPassword: encryptionKey)
        let decryptedMessage = String(data: decryptedData, encoding: .utf8)!
        return decryptedMessage
    }
    
}
