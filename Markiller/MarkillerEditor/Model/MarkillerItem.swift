//
//  MarkillerItem.swift
//  Markiller
//
//  Created by teason23 on 2021/5/18.
//

import Foundation
import HandyJSON

public enum MKSyntaxType: Int, HandyJSONEnum {
    case normal
    case headers
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



public class MarkillerItem: HandyJSON {
    var paragraphType: MKSyntaxType = .normal
    var contentString: String = ""
    
    required public init() {}
}
