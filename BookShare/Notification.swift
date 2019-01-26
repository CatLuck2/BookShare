//
//  Notification.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class Notification: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NotificationCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationCell")
        
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = 65

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        return cell
    }
    
    //お知らせを読み込む
    func loadNotification() {
        let ref = Database.database().reference()
        //画像のURL
        //メッセージ本文
        ref.child("User")
//            .queryOrdered(byChild: userID.text)
            .observe(.value) { (snap,error) in
                let snapdata = snap.value as! [String:NSDictionary]
                if snapdata != nil {
                    return
                }
                for key in snapdata.keys.sorted() {
                    let read_data = snapdata[key]
                    if let message = read_data!["message"] as? String {
                        
                    }
                }
        }
    }

}
