//
//  Realm.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/11.
//  Copyright © 2020 OIMO. All rights reserved.
//

import Foundation
import RealmSwift

class PiechartResultData: Object{
    @objc dynamic var date: String = ""
    @objc dynamic var piechartImagePass: Data? = nil
    
    override static func primaryKey() -> String? {
           return "date"
    }
}
