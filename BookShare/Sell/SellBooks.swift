//
//  SellBooks.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/01/11.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit

class SellBooks: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //選択した本の番号
    var numberOfBook:Int!
    //設定項目
    let array = ["タイトル","カテゴリ","本の状態"]
    //出品画面に渡す配列
    var settingArray = ["","",""]
    //出品する本の表示画像の名前に使用するユーザーID
    var userID = ""
    //出品する本の表紙画像名
    var fileName = ""
    //SellBookから画像を受け取る
    var getImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = getImage
        tableView.delegate = self
        tableView.dataSource = self
        //空のセルを削除
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "本の情報"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        cell.detailTextLabel?.text = settingArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let titleAlert = UIAlertController(title: "タイトル", message: "本のタイトルを入力してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //textFieldを配列に格納
                guard let textfield:[UITextField] = titleAlert.textFields else {return}
                //配列からテキストを取り出す
                for textField in textfield {
                    switch textField.tag {
                    case 0:
                        if textField.text == "" {
                            return
                        } else {
                            //textFieldに入力した内容をsettingArray[0]に格納
                            self.settingArray[0] = textField.text!
                            tableView.reloadData()
                            titleAlert.dismiss(animated: true, completion: nil)
                        }
                    default: break
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
                titleAlert.dismiss(animated: true, completion: nil)
            })
            //アラートにtextFieldを追加
            titleAlert.addTextField { (text:UITextField!) in
                text.placeholder = "例：金持ち父さんと貧乏父さん"
                text.tag = 0
            }
            titleAlert.addAction(okAction)
            titleAlert.addAction(cancelAction)
            self.present(titleAlert, animated: true, completion: nil)
        case 1:
            //選択肢をセルで表示したTableViewに遷移
            let vc = storyboard?.instantiateViewController(withIdentifier: "setting") as! SettingDataOfBook
            vc.flag = "カテゴリ"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            //選択肢をセルで表示したTableViewに遷移
            let vc = storyboard?.instantiateViewController(withIdentifier: "setting") as! SettingDataOfBook
            vc.flag = "本の状態"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @IBAction func imageTapGesture(_ sender: Any) {
        //アルバムを指定
        let sourceType:UIImagePickerController.SourceType
            = UIImagePickerController.SourceType.photoLibrary
        //アルバムを立ち上げる
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            //アルバム画面を開く
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func finishSetting(_ sender: Any) {
        let vc = self.navigationController!.viewControllers[0] as! SellBook
        vc.book = settingArray
        vc.books[numberOfBook] = vc.book
        vc.book = ["","",""]
        if let _ = imageView.image as? UIImage {
            vc.imagesOfBook[numberOfBook] = imageView.image!
        } else {}
        if fileName == "" {fileName = "sample.png"}
        vc.filenamesOfBook[numberOfBook] = fileName
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imagePickerController
        (_ picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //imageにアルwバムで選択した画像が格納される
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let fileURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            //選択した画像名を取得
            fileName = fileURL.lastPathComponent
            //ImageViewに
            self.imageView.image = image
            //アルバム画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
