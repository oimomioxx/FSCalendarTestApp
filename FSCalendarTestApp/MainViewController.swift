//
//  ViewController.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/03.
//  Copyright © 2020 OIMO. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift
import CalculateCalendarLogic


class MainViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var piechartImageResultView: UIImageView!
    @IBOutlet weak var firstText: UILabel!
    
    var year = 0
    var month = 0
    var day = 0
    var piechartImage:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.dataSource = self
        self.calendar.delegate = self
        let date = Date()
        let calendarSet = Calendar.current
        year = calendarSet.component(.year, from: date)
        month = calendarSet.component(.month, from: date)
        day = calendarSet.component(.day, from: date)
        let selectDate = calendarSet.date(from: DateComponents(year: year, month: month, day: day))
        calendar.select(selectDate)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
        
        //        レルムから円グラフの画像データ読み込みと表示
        DispatchQueue(label: "background").async {
            let realm = try! Realm()
            
            
            if let savedPiechartData = realm.objects(PiechartResultData.self).filter("date == '\(self.year).\(self.month).\(self.day)'").last {
                
                let piechartImagePNG = savedPiechartData.piechartImagePass
                
                
                self.piechartImage = piechartImagePNG?.toImage()
                DispatchQueue.main.async {
                    
                    self.piechartImageResultView.image = self.piechartImage
                    self.firstText.text = ""
                    
                }
            }
        }
        
        
    }
    
    
    
    
    //    祝日判定処理↓
    
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    
    
    //    カレンダーの日付がタップされた時の処理
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        let tmpDate = Calendar(identifier: .gregorian)
        year = tmpDate.component(.year, from: date)
        month = tmpDate.component(.month, from: date)
        day = tmpDate.component(.day, from: date)
        
        //        レルムから円グラフデータの画像読み込みと表示
        //        空の場合はテキスト表示
        DispatchQueue(label: "background").async {
            let realm = try! Realm()
            if let savedPiechartData = realm.objects(PiechartResultData.self).filter("date == '\(self.year).\(self.month).\(self.day)'").last {
                
                let piechartImagePNG = savedPiechartData.piechartImagePass
                
                
                self.piechartImage = piechartImagePNG?.toImage()
                DispatchQueue.main.async {
                    self.piechartImageResultView.image = self.piechartImage
                    self.firstText.text = ""
                }
            } else {
                DispatchQueue.main.async {
                    self.firstText.text = "１日の終わりに右上の＋からグラフを作成しましょう"
                    self.piechartImageResultView.image = nil
                }
                
            }
        }
        
        
    }
    
//    モーニングボタンで画面遷移
    @IBAction func morningButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMorningJournal", sender: nil)
    }
    
//    ナイトボタンで画面遷移
    @IBAction func nightButton(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "toNightJournal", sender: nil)
        
    }
    
    
    
//    各画面値の受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddPiechart" {
            
            let nextView = segue.destination as! AddPiechartViewController
            
            nextView.dateResult = ("\(year).\(month).\(day)")
        } else if segue.identifier == "toMorningJournal" {
            let nextView = segue.destination as! AddMorningTextViewController
            
            nextView.dateResult = ("\(year).\(month).\(day)")
        } else if segue.identifier == "toNightJournal" {
            let nextView = segue.destination as! AddNightTextViewController
            
            nextView.dateResult = ("\(year).\(month).\(day)")
        }
    }
}

