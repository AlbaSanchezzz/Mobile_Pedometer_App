import Foundation
import MessageUI
import SwiftUI

/// Wraps MFMessageComposeViewController for SwiftUI
class MessagingManager: NSObject, MFMessageComposeViewControllerDelegate {
    static let shared = MessagingManager()
    
    func sendSMS(withBody body: String, recipients: [String], from controller: UIViewController) {
        guard MFMessageComposeViewController.canSendText() else {
            print("❌ SMS not available")
            return
        }
        let msg = MFMessageComposeViewController()
        msg.messageComposeDelegate = self
        msg.recipients = recipients
        msg.body = body
        controller.present(msg, animated: true)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
        switch result {
        case .sent:    print("SMS sent")
        case .cancelled: print("SMS cancelled")
        case .failed:  print("SMS failed")
        @unknown default: break
        }
    }
}
