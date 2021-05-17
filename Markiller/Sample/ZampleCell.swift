//
//  ZampleCell.swift
//  Markiller
//
//  Created by teason23 on 2021/5/18.
//

import UIKit
import XTTable
import XTlib

class ZampleCell: UITableViewCell {
    
    public func xt_configure(_ model: String) {        
        textLabel?.text = model
        contentView.backgroundColor = XTColorFetcher.sharedInstance().randomColor()
    }
}
