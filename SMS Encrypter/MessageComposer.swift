//
//  MessageComposer.swift
//  SMS Encrypter
//
//  Created by Matt Nolan on 1/6/18.
//  Copyright © 2018 Matt Nolan. All rights reserved.
//

import Foundation
import MessageUI


let textMessageRecipients: Array<Any> = [] // for pre-populating the recipients list

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(smsBody: String, receiverNumber: String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = [receiverNumber]
        messageComposeVC.body =  smsBody
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
