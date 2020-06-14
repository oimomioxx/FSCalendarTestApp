//
//  TextDataRealm.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/22.
//  Copyright © 2020 OIMO. All rights reserved.
//

import Foundation
import RealmSwift

class MorningTextData: Object{
    @objc dynamic var date: String = ""
    @objc dynamic var appreciationTextData1 = ""
    @objc dynamic var appreciationTextData2 = ""
    @objc dynamic var appreciationTextData3 = ""
    
    @objc dynamic var makeGoodTextData1 = ""
    @objc dynamic var makeGoodTextData2 = ""
    @objc dynamic var makeGoodTextData3 = ""
    
    override static func primaryKey() -> String? {
           return "date"
    }
    
}

