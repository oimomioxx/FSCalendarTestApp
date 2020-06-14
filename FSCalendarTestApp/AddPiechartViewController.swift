//
//  AddPiechartViewController.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/03.
//  Copyright © 2020 OIMO. All rights reserved.
//

import UIKit
import RealmSwift

class AddPiechartViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var piechartView: UIView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var piechartImageView: UIView!
    
//    MainViewControllerより値の受け取り
    var dateResult = ""
    var pickerDataList = ["未選択", "睡眠","勉強","仕事","食事","遊び","運動"]
    var pickerColor: [UIColor] = [.white, .blue, .red, .purple, .orange, .gray, .green]
    var selectedPickerColor: UIColor = .white
    var startRadian = 0.0
    var endRadian = 0.0
    var piechartImage: UIImage?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        最初の白い円グラフ表示
        print("\(dateResult)")
            let grayPath = UIBezierPath()
            grayPath.addArc(withCenter: CGPoint(x: piechartView.frame.width/2, y: piechartView.frame.height/2 - 25), // 中心
                radius: self.piechartView.frame.height/5.5, // 半径r
                startAngle: 0.0, // 開始角度
                endAngle: .pi * 2, // 終了角度
                clockwise: true) // 時計回り
            
            let grayLayer = CAShapeLayer()
            grayLayer.path = grayPath.cgPath
            grayLayer.fillColor = UIColor.clear.cgColor // 真ん中の塗り色
            grayLayer.strokeColor = UIColor.white.cgColor // 線の色
            grayLayer.lineWidth = 15.0 // 線の幅
            self.piechartView.layer.addSublayer(grayLayer)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        dateLabel.text = dateResult
        
        
    }
    
    
    //    UIPickerViewのdelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return pickerDataList[row]
    }
    
    //    PickereViewの選択で色取得
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerColor = pickerColor[row]
    }
    
//    スタートUISliderの処理
    @IBAction func startTimeSlider(_ sender: UISlider) {
        let startSliderValue = Int(sender.value)
        startRadian = Double(startSliderValue)
        
        if startSliderValue % 2 == 0 {
            startTimeLabel.text = "\(startSliderValue / 2):00"
        } else {
            startTimeLabel.text = "\(startSliderValue / 2):30"
        }
    }
    
//    エンドUISliderの処理
    @IBAction func endTimeSlider(_ sender: UISlider) {
        let startSliderValue = Int(sender.value)
        endRadian = Double(startSliderValue)
        
        if startSliderValue % 2 == 0 {
            endTimeLabel.text = "\(startSliderValue / 2):00"
        } else {
            endTimeLabel.text = "\(startSliderValue / 2):30"
        }
    }
    
//    円グラフの追加ボタンの処理
    @IBAction func addButton(_ sender: UIButton) {
        
        let timeRadian = .pi * 2.0 / 48.0
        
        let grayPath = UIBezierPath()
        grayPath.addArc(withCenter: CGPoint(x: self.piechartView.frame.width/2, y: self.piechartView.frame.height/2 - 25), // 中心
            radius: self.piechartView.frame.height/5.5, // 半径r
            startAngle: CGFloat(.pi * -0.5 + startRadian * timeRadian), // 開始角度
            endAngle: CGFloat(.pi * -0.5 + endRadian * timeRadian), // 終了角度
            clockwise: true) // 時計回り
        
        let grayLayer = CAShapeLayer()
        grayLayer.path = grayPath.cgPath
        grayLayer.fillColor = UIColor.clear.cgColor // 真ん中の塗り色
        grayLayer.strokeColor = selectedPickerColor.cgColor // 線の色
        grayLayer.lineWidth = 15.0 // 線の幅
        self.piechartView.layer.addSublayer(grayLayer)
    }
    
//    保存ボタンの処理
    @IBAction func saveButton(_ sender: UIButton) {
        
        let title = "グラフの保存"
               let message = "グラフが保存されました"
               let okText = "OK"

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
               alert.addAction(okayButton)

               present(alert, animated: true, completion: nil)
        
//        作成した円グラフをUIImageに変換
        piechartImage = piechartView.toImage()
//        円グラフのUIImageをPNGに変換
        let imagePNG = piechartImage?.toPNGData()
        
//        レルム呼び出し
        let realm = try! Realm()
//        レルムに書き込む内容
        let dayPiechartData = PiechartResultData()
        dayPiechartData.date = dateResult
        dayPiechartData.piechartImagePass = imagePNG
        
        
//        レルムに追加
        try! realm.write() {
            realm.add(dayPiechartData, update: .all)
        }
        
//        画面をメインビューに移す
        self.navigationController?.popViewController(animated: true)

        }
        
}
