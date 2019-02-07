//
//  SignIn.swift
//  BookShare
//
//  Created by 藤澤洋佑 on 2019/02/07.
//  Copyright © 2019年 NEKOKICHI. All rights reserved.
//

import UIKit
import Firebase

class SignIn: UIViewController {
    
    @IBOutlet weak var mailForm: UITextField!
    @IBOutlet weak var passForm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailForm.layer.borderWidth = 1
        mailForm.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: Any) {
        //ちゃんと入力されてるかの確認
        if mailForm.text != "" && passForm.text != "" {
            Auth.auth().signIn(withEmail: mailForm.text!, password: passForm.text!) { (user, error) in
                if error == nil {
                    //ログイン状態をtrueに
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                    //ホーム画面へ移行
                    let storyboard = UIStoryboard(name: "Main", bundle:Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "Main")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                } else {
                    let alert = UIAlertController(title: "エラー", message: "メールアドレスまたはパスワードが間違ってます。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "エラー", message: "入力されてない箇所があります。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                        let resetFailedAlert = UIAlertController(title: "エラー", message: error.localizedDescription, preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    } else {
                        let resetEmailSentAlert = UIAlertController(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
}
