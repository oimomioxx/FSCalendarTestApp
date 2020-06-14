//
//  NightTextDataRealm.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/22.
//  Copyright © 2020 OIMO. All rights reserved.
//

import Foundation
import RealmSwift

class NightTextData: Object{
    @objc dynamic var date: String = ""
    @objc dynamic var goodTextData1 = ""
    @objc dynamic var goodTextData2 = ""
    @objc dynamic var goodTextData3 = ""
    
    @objc dynamic var improvementTextData = ""
    
    
    override static func primaryKey() -> String? {
           return "date"
    }
    
}
