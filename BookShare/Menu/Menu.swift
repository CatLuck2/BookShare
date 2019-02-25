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
    
    //共有用のインスタンス
    static let menu = Menu()
    //遷移元のViewControllerを受け取る
    var vc = UITabBarController()
    
    //メニューを表示
    func menuAlert() -> UIAlertController {
        //アラート
        let alert = UIAlertController(title: "メニュー", message: nil, preferredStyle: .actionSheet)
        //このアプリについて
        alert.addAction(UIAlertAction(title: "BookShareについて", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "menu", sender: nil)
//            let sb = UIStoryboard(name: "MenuView", bundle: Bundle.main)
//            let vc = sb.instantiateViewController(withIdentifier: "about") as! about
//            self.definesPresentationContext = true
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true, completion: nil)
//            self.tabBarController?.present(vc, animated: true, completion: nil)
//            self.goMenuView("about")
//            let aboutI = about.aboutVC
//            aboutI.vc = self.vc
        }))
        //このアプリの使い方
        alert.addAction(UIAlertAction(title: "BookShareの使い方", style: .default, handler: { (action) in
            self.goMenuView("howtouse")
//            let howtouseI = howtouse.howtouseVC
//            howtouseI.vc = self.vc
        }))
        //お問い合わせ
        alert.addAction(UIAlertAction(title: "お問い合わせ", style: .default, handler: { (action) in
//            self.goMenuView("contact")
//            let ContactI = Contact.contactVC
//            ContactI.vc = self.vc
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
        let sb = UIStoryboard(name: "MenuView", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: storyboardID)
//        switch storyboardID {
//        case "about":
//            vc = sb.instantiateViewController(withIdentifier: storyboardID) as! about
//        case "howtouse":
//            vc = sb.instantiateViewController(withIdentifier: storyboardID) as! howtouse
//        case "contact":
//            vc = sb.instantiateViewController(withIdentifier: storyboardID) as! Contact
//        default:
//            break
//        }
//        self.tabBarController?.present(vc, animated: true, completion: nil)
////        let rootViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        self.tabBarController?.present(vc, animated: true, completion: nil)
//        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
