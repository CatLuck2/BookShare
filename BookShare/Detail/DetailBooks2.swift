//
//  DetailBooks2.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class DetailBooks2: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //ホームで選択した本のデータ
    var bookData = [String:String]()
    //表示する本の画像URL
    var imageURL = URL(string: "")
    //ホームで選択した本の各種データ
    var cellArray = ["タイトル","カテゴリ","本の状態"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //空のセルを削除
        tableView.tableFooterView = UIView()
        //NavigationBarのタイトル
        self.navigationItem.title = bookData["Title"]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "本の情報"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellArray[indexPath.row]
        switch cellArray[indexPath.row] {
        case "タイトル":
            cell.detailTextLabel?.text = bookData["Title"]
        case "カテゴリ":
            cell.detailTextLabel?.text = bookData["Category"]
        case "本の状態":
            cell.detailTextLabel?.text = bookData["State"]
        default:
            break
        }
        return cell
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
