//
//  GoodList.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class GoodList: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
