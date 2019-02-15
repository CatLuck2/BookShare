//
//  Menu.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/14.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Foundation

class Menu: UIViewController {
    
    //メニューを表示
    func menuAlert() -> UIAlertController {
        //アラート
        let alert = UIAlertController(title: "メニュー", message: nil, preferredStyle: .actionSheet)
        //このアプリについて
        alert.addAction(UIAlertAction(title: "このアプリについて", style: .default, handler: { (action) in
            self.goMenuView("about")
        }))
        //このアプリの使い方
        alert.addAction(UIAlertAction(title: "このアプリの使い方", style: .default, handler: { (action) in
            self.goMenuView("howtouse")
        }))
        //お問い合わせ
        alert.addAction(UIAlertAction(title: "お問い合わせ", style: .default, handler: { (action) in
            self.goMenuView("contact")
        }))
        //サインアウト
        alert.addAction(UIAlertAction(title: "サインアウト", style: .destructive, handler: { (action) in
            let signclass = SignOut()
            signclass.signout()
        }))
        //キャンセル
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        //alertを返り血に
        return alert
    }
    
    //AlertViewControllerをMenuView.Swiftに渡す
    func goMenuView(_ storyboardID:String) {
        //MenuView.storyboardに遷移
        let storyboard = UIStoryboard(name: "MenuView", bundle:Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
}
