//
//  UIImageExtension.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/11.
//  Copyright © 2020 OIMO. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

    // MARK: Public Methods

    /// イメージ→PNGデータに変換する
    ///
    /// - Returns: 変換後のPNGデータ
    func toPNGData() -> Data {
        guard let data = self.pngData() else {
            print("イメージをPNGデータに変換できませんでした。")
            return Data()
        }

        return data
    }

}

