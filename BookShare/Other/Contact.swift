//
//  Contact.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/14.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import MessageUI

class Contact: UIViewController,MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendMail()
    }
    
    //新規メールを開く
    func sendMail() {
        //メール送信が可能なら
        if MFMailComposeViewController.canSendMail() {
            //MFMailComposeVCのインスタンス
            let mail = MFMailComposeViewController()
            //MFMailComposeのデリゲート
            mail.mailComposeDelegate = self
            //送り先
            mail.setToRecipients(["test1@gmail.com","test2@gmail.com"])
            //Cc
            mail.setCcRecipients(["mike@gmail.com"])
            //Bcc
            mail.setBccRecipients(["amy@gmail.com"])
            //件名
            mail.setSubject("件名")
            //メッセージ本文
            mail.setMessageBody("このメールはMFMailComposeViewControllerから送られました。", isHTML: false)
            //メールを表示
            self.present(mail, animated: true, completion: nil)
        //メール送信が不可能なら
        } else {
            //アラートで通知
            let alert = UIAlertController(title: "No Mail Accounts", message: "Please set up mail accounts", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(dismiss)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //エラー処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            print(error)
        } else {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
}
