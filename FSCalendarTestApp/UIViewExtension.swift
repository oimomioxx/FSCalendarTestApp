//
//  UIViewToUIImage.swift
//  FSCalendarTestApp
//
//  Created by 井本大貴 on 2020/05/07.
//  Copyright © 2020 OIMO. All rights reserved.
//

import Foundation
import UIKit

/// UIView拡張(イメージ)
public extension UIView {

    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("現在のコンテキストを取得できませんでした。")
            return UIImage()
        }

        self.layer.render(in: context)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            print("ビューをイメージに変換できませんでした。")
            return UIImage()
        }

        UIGraphicsEndImageContext()

        return image
    }
    
    
}
