//
//  howtouse.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/17.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class howtouse: UIViewController {
    
    //共有用のインスタンス
    static let howtouseVC = howtouse()
    //遷移元のViewControllerを受け取る
    var vc = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        //遷移元へ戻る
    }

}
