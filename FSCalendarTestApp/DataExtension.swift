//
//  DataExtension.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/14.
//  Copyright © 2020 OIMO. All rights reserved.
//

import Foundation
import UIKit

/// Data拡張(イメージ)
public extension Data {

    // MARK: Public Methods

    /// データ→イメージに変換する
    ///
    /// - Returns: 変換後のイメージ
    func toImage() -> UIImage {
        guard let image = UIImage(data: self) else {
            print("データをイメージに変換できませんでした。")
            return UIImage()
        }

        return image
    }

}
