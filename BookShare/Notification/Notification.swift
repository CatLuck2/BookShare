//
//  Notification.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//
/*
 問題点：セルでの読み込み時、データがない
 
 */

import UIKit
import Firebase
import FirebaseUI

class Notification: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //userID
    var userID = "userID"
    
    //通知メッセージを格納する配列
    var notificationArray = [[String:String]]()
    
    //画像URLを格納する配列
    var photos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotification()
        
        tableView.register(UINib(nibName: "NotificationCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationCell")
        
        tableView.estimatedRowHeight = 96
        tableView.rowHeight = 96

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Storage参照
        let storageref = Storage.storage().reference(forURL: "gs://bookshare-b78b4.appspot.com").child(userID).child("Notification").child(notificationArray[indexPath.row]["icon"]!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        //通知本文を表示
        cell.message.text = notificationArray[indexPath.row]["message"]!
        //画像を表示
        cell.icon.sd_setImage(with: storageref)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.estimatedRowHeight = 96
//        return UITableView.automaticDimension
//    }
    
    //お知らせを読み込む
    func loadNotification() {
        //初期化
        notificationArray = [[String:String]]()
        //データベース参照
        let ref = Database.database().reference(fromURL: "https://bookshare-b78b4.firebaseio.com/")
        //データを取得
        ref.child("Notification").child(userID).observe(.value) { (snap) in
            for data in snap.children {
                let snapdata = data as! DataSnapshot
                //辞書型に変換
                let item = snapdata.value as! [String:String]
                //配列に追加
                self.notificationArray.append(item)
            }
            //tableViewを更新
            self.tableView.reloadData()
        }
    }
    
    @IBAction func menu(_ sender: Any) {
        menuAlert()
    }
    
    //メニュー用のアラート
    func menuAlert() {
        //アラート
        let alert = UIAlertController(title: "メニュー", message: nil, preferredStyle: .actionSheet)
        //このアプリについて
        alert.addAction(UIAlertAction(title: "BookShareについて", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.go("about")
        }))
        //このアプリの使い方
        alert.addAction(UIAlertAction(title: "使い方", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.go("howtouse")
        }))
        //お問い合わせ
        alert.addAction(UIAlertAction(title: "お問い合わせ", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.go("contact")
        }))
        //サインアウト
        alert.addAction(UIAlertAction(title: "サインアウト", style: .destructive, handler: { (action) in
            let signclass = SignOut()
            signclass.signout()
        }))
        //キャンセル
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
    
    //遷移
    func go(_ identifier:String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
    
    //お知らせの画像を取得
    func getImageURL() {
        
    }

}
