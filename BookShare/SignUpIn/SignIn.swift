//
//  SignIn.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/07.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase

class SignIn: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mailForm: UITextField!
    @IBOutlet weak var passForm: UITextField!
    
    //UserDataClass
    var userDataClass = UserData.userClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailForm.delegate = self
        passForm.delegate = self

        mailForm.layer.borderWidth = 1
        mailForm.layer.cornerRadius = 10
        passForm.layer.borderWidth = 1
        passForm.layer.cornerRadius = 10
    }
    
    @IBAction func signIn(_ sender: Any) {
        //ちゃんと入力されてるかの確認
        if mailForm.text != "" && passForm.text != "" {
            Auth.auth().signIn(withEmail: mailForm.text!, password: passForm.text!) { (user, error) in
                if error == nil {
                    //UserDefaults
                    let ud = UserDefaults.standard
                    //ログイン状態をtrueに
                    ud.set(true, forKey: "loginStatus")
                    //userDataIDをセット
                    //UserDefaultsとUserDataクラスにuserIDを保存
                    ud.set((Auth.auth().currentUser?.uid)!, forKey: "userDataID")
                    ud.synchronize()
                    self.userDataClass.userID = ud.string(forKey: "userDataID")!
                    //ユーザーデータを取得
                    let readD = readData()
//                    readD.readMyData()
                    //ホーム画面へ移行
                    let storyboard = UIStoryboard(name: "Main", bundle:Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "Main")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                } else {
                    self.alert(title: "エラー", message: "メールアドレスまたはパスワードが間違ってます。", actiontitle: "OK")
                }
            }
        } else {
            self.alert(title: "エラー", message: "入力されてない箇所があります。", actiontitle: "OK")
        }
    }
    
    //会員登録画面へ飛行
    @IBAction func changeToSignUp(_ sender: Any) {
        performSegue(withIdentifier: "gosignup", sender: nil)
    }
    
    @IBAction func resetPass() {
        let forgotPasswordAlert = UIAlertController(title: "パスワードをリセット", message: "メールアドレスを入力してください", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "test@gmail.com"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "リセット", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.alert(title: "エラー", message: "このメールアドレスは登録されてません。", actiontitle: "OK")
                    } else {
                        self.alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
                    }
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailForm.resignFirstResponder()
        passForm.resignFirstResponder()
    }
    
}
