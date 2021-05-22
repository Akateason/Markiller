//
//  MKIHeaderItem.swift
//  Markiller
//
//  Created by teason23 on 2021/5/22.
//

import UIKit

class MKIHeaderItem: MarkillerItem {
    
    var headerSize: Int = 1
    
    private let kSizeH1: CGFloat = 30.0
    private let kSizeH2: CGFloat = 28.0
    private let kSizeH3: CGFloat = 26.0
    private let kSizeH4: CGFloat = 24.0
    private let kSizeH5: CGFloat = 22.0
    private let kSizeH6: CGFloat = 20.0
    
    func itemFont() -> UIFont? {
        switch headerSize {
        case 1:
            return UIFont.systemFont(ofSize: kSizeH1)
        case 2:
            return UIFont.systemFont(ofSize: kSizeH2)
        case 3:
            return UIFont.systemFont(ofSize: kSizeH3)
        case 4:
            return UIFont.systemFont(ofSize: kSizeH4)
        case 5:
            return UIFont.systemFont(ofSize: kSizeH5)
        case 6:
            return UIFont.systemFont(ofSize: kSizeH6)
        default:
            break
        }
        return nil
    }
}
