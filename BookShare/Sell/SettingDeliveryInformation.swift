//
//  SettingDeliveryInformation.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/30.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class SettingDeliveryInformation: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    //どの配送情報が入力されたのかを判別
    var flag = ""
    var array = ["","",""]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //選択した項目でセルの内容をかえる
        switch flag {
        case "配送料の負担":
            array = ["元払い(発送者)","着払い(受取人)"]
        case "発送の方法":
            array = ["ゆうメール","レターパック","普通郵便","クロネコヤマト","ゆうパック","クリックポスト"]
        case "発送日の目安":
            array = ["1~2日","3~4日","5~6日","7~8日"]
        default:
            break
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as! SellBook
        switch flag {
        case "配送料の負担":
            vc.deliveryInformation[0] = array[indexPath.row]
        case "発送の方法":
            vc.deliveryInformation[1] = array[indexPath.row]
        case "発送日の目安":
            vc.deliveryInformation[2] = array[indexPath.row]
        default:
            break
        }
        self.navigationController?.popViewController(animated: true)
    }

}
