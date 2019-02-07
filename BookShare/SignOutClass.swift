//
//  SignOutClass.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/07.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import Foundation
import Firebase

class SignOut {
    //ログイン中ならログアウト、そうでないなら無反応
    func signout() {
        if Auth.auth().currentUser != nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("success logout")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        } else {
            return
        }
        
        //ログイン状態をfalseに
        let ud = UserDefaults.standard
        ud.set(false, forKey: "isLogin")
        ud.synchronize()
        
        //ログイン画面に移行
        let storyboard = UIStoryboard(name: "SignUpIn", bundle:Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "gosignin")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        
        
        
    }
}
