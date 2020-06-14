//
//  AddNightTextViewController.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/22.
//  Copyright © 2020 OIMO. All rights reserved.
//

import UIKit
import RealmSwift

class AddNightTextViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var goodText1: UITextField!
   @IBOutlet weak var goodText2: UITextField!
   @IBOutlet weak var goodText3: UITextField!
   
   @IBOutlet weak var improvementText: UITextField!
    
    var dateResult = ""
    
    var selectedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        dateLabel.text = dateResult
        goodText1.delegate = self
        goodText2.delegate = self
        goodText3.delegate = self
        improvementText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        レルム呼び出し
        let realm = try! Realm()
//        レルムからテキスト呼び出し
        if let savedNightTextData = realm.objects(NightTextData.self).filter("date == '\(self.dateResult)'").last {
            
            
            self.goodText1.text = savedNightTextData.goodTextData1
            self.goodText2.text = savedNightTextData.goodTextData2
            self.goodText3.text = savedNightTextData.goodTextData3
            self.improvementText.text = savedNightTextData.improvementTextData
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            switch selectedTextField {
            case improvementText:
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                } else {
                    let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                    self.view.frame.origin.y -= suggestionHeight
                }
            default:
                break
            }
            
            
        }
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //画面をタップしてキーボードを閉じる処理
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        //リターンキーでキーボードを閉じる処理
        textField.resignFirstResponder()
        
        return true
    }
    
    
//    保存ボタンの処理
    @IBAction func nightTextSaveButton(_ sender: UIButton) {
        let title = "おやすみなさい"
        let message = "夜の日記が保存されました"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        
        present(alert, animated: true, completion: nil)
        
        let realm = try! Realm()
        let addNightText = NightTextData()
        addNightText.date = dateResult
        addNightText.goodTextData1 = goodText1.text ?? ""
        addNightText.goodTextData2 = goodText2.text ?? ""
        addNightText.goodTextData3 = goodText3.text ?? ""
        addNightText.improvementTextData = improvementText.text ?? ""
        
        try! realm.write() {
            realm.add(addNightText, update: .all)
        }
    }
    
}
