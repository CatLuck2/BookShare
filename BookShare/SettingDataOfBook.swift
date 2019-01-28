//
//  SettingDataOfBook.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/26.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class SettingDataOfBook: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //カテゴリ、本の状態かを判断する
    var flag = ""
    
    //表示する要素
    var array:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        //空のセルを削除
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //選択した項目でセルの内容をかえる
        if flag == "カテゴリ" {
            array = ["文学","人文","社会","IT","科学","フィクション","ノンフィクション","スポーツ","語学","旅行","料理","ビジネス","投資"]
        } else if flag == "本の状態" {
            array = ["新品","目立った傷なし","ボロボロ"]
        }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as! SellBooks
        if flag == "カテゴリ" {
            vc.settingArray[1] = array[indexPath.row]
        } else if flag == "本の状態" {
            vc.settingArray[2] = array[indexPath.row]
            print("確認")
            print(vc.settingArray[2]);
            print("らりるれろ")
         print(vc.settingArray);
        }
        self.navigationController?.popViewController(animated: true)
    }

}
