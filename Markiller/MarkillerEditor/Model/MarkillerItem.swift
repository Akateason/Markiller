//
//  MarkillerItem.swift
//  Markiller
//
//  Created by teason23 on 2021/5/18.
//

import Foundation
import HandyJSON

/// header

let kMarkillerItemDefaultFontSize:CGFloat  = 16.0

public enum MKSyntaxType: Int, HandyJSONEnum {
    case normal
    case headers
}

protocol MarkillerItemProtocol: NSObjectProtocol {
    func itemFont() -> UIFont?
}

extension MarkillerItemProtocol {
    func itemFont() -> UIFont? {
        return UIFont.systemFont(ofSize: kMarkillerItemDefaultFontSize)
    }
}

/// CLASS MarkillerItem

public class MarkillerItem: NSObject, HandyJSON, MarkillerItemProtocol {
    
    weak var delegate: MarkillerItemProtocol?
    
    var paragraphType: MKSyntaxType = .normal
    var contentString: String = ""
    
    required public override init() {
        super.init()
        // self.delegate = self
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper >>> self.delegate
    }

}












//enum MKInlineType {
//    case <#case#>
//}

//typedef NS_ENUM(int, MKSyntaxType) {
//    MKSyntaxUnknown,
//
//    // 标题
//    MKSyntaxHeaders, // h1-h6
//
////    // 列表
////    MKSyntaxOLLists, // orderlist
////    MKSyntaxULLists, // bulletlist
////    MKSyntaxTaskLists, // tasklist
////
////    // block
////    MKSyntaxBlockquotes, // 块引用
////    MKSyntaxCodeBlock, // 代码块
//
//    NumberOfMKSyntax
//} ;

//typedef NS_ENUM(int, MKInlineType) {
//    MKInlineUnknown = 99,
//
////    MKInlineBold,
////    MKInlineItalic,
////    MKInlineBoldItalic,
////    MKInlineDeletions,
////    MKInlineInlineCode,
////    MKInlineLinks,
////
////    MKInlineImage,
////    MKInlineEscape ,
////
////    NumberOfMKInline
//} ;


