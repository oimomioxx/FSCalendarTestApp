//
//  AddMorningTextViewController.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/22.
//  Copyright © 2020 OIMO. All rights reserved.
//

import UIKit
import RealmSwift

class AddMorningTextViewController : UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var appreciationText1: UITextField!
    @IBOutlet weak var appreciationText2: UITextField!
    @IBOutlet weak var appreciationText3: UITextField!
    
    @IBOutlet weak var makeGoodText1: UITextField!
    @IBOutlet weak var makeGoodText2: UITextField!
    @IBOutlet weak var makeGoodText3: UITextField!
    //    日付の取得
    var dateResult = ""
    
    var selectedTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        dateLabel.text = dateResult
        appreciationText1.delegate = self
        appreciationText2.delegate = self
        appreciationText3.delegate = self
        makeGoodText1.delegate = self
        makeGoodText2.delegate = self
        makeGoodText3.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        レルム呼び出し
        let realm = try! Realm()
//        レルムからテキスト表示
        if let savedMorningTextData = realm.objects(MorningTextData.self).filter("date == '\(self.dateResult)'").last {
            self.appreciationText1.text = savedMorningTextData.appreciationTextData1
            self.appreciationText2.text = savedMorningTextData.appreciationTextData2
            self.appreciationText3.text = savedMorningTextData.appreciationTextData3
            self.makeGoodText1.text = savedMorningTextData.makeGoodTextData1
            self.makeGoodText2.text = savedMorningTextData.makeGoodTextData2
            self.makeGoodText3.text = savedMorningTextData.makeGoodTextData3
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
    }
    
//    テキストフィールドがキーボードに隠れない様に処理
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            switch selectedTextField {
            case makeGoodText1, makeGoodText2, makeGoodText3:
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
    
//    キーボードを閉じた時にViewを元の位置に戻す処理
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
        //画面をタップした時にキーボードを閉じる処理
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // リターンキーでキーボードを閉じる処理
        textField.resignFirstResponder()
        
        return true
    }
    
    //    保存ボタンの処理
    @IBAction func morningTextSaveButton(_ sender: UIButton) {
        let title = "おはようございます"
        let message = "朝の日記が保存されました"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        
        present(alert, animated: true, completion: nil)
        
//        レルム呼び出し
        let realm = try! Realm()
        let addMorningText = MorningTextData()
        addMorningText.date = dateResult
        addMorningText.appreciationTextData1 = appreciationText1.text ?? ""
        addMorningText.appreciationTextData2 = appreciationText2.text ?? ""
        addMorningText.appreciationTextData3 = appreciationText3.text ?? ""
        addMorningText.makeGoodTextData1 = makeGoodText1.text ?? ""
        addMorningText.makeGoodTextData2 = makeGoodText2.text ?? ""
        addMorningText.makeGoodTextData3 = makeGoodText3.text ?? ""
        
        try! realm.write() {
            realm.add(addMorningText, update: .all)
        }
    }
    
}

