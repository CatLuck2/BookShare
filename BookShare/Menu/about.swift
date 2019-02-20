//
//  about.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/17.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class about: UIViewController {
    
    //共有用のインスタンス
    static let aboutVC = about()
    //遷移元のViewControllerを受け取る
    var vc = UITabBarController()
    
    @IBAction func back(_ sender: Any) {
        //遷移元へ戻る
        self.present(vc, animated: true, completion: nil)
    }
    
}
