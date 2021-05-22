//
//  MarkillerEditor.swift
//  Markiller
//
//  Created by teason23 on 2021/5/18.
//
/// 存储数据全部用Json,  [{},{},{}, ...]
/// 入口, 出口 都用jsonModel
/// 换行 - 解析段落.
/// markdown只是输入时候做转换. 不存储任何markdown语法在文字中.
/// 先做最简单的几个类型:
/// 标题, 正文
/// 每次回车输出一个段落类型, 在行内输入时判断此段落类型
/// 性能优化: 1. 缓存 2. 局部渲染
///

import Foundation
import UIKit

// MARK: LIFE
public class MarkillerEditor: UITextView, UITextViewDelegate {
    
    let kMKEditor_FlexValue:CGFloat = 30.0
        
    // current typing item
    var currentTypingItem: MarkillerItem?
    // datas
    var paragraphList = [MarkillerItem]()
    
        
    
    deinit {
        print("******** Editor DEALLOC ********")
    }
            
    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        currentTypingItem = MarkillerItem() /// TODO : parser文章
        
        font = UIFont.systemFont(ofSize: kMarkillerItemDefaultFontSize)
        keyboardDismissMode = .onDrag
        delegate = self
        smartDashesType = .no
    }
}



// MARK: PUBLIC
extension MarkillerEditor {
    
    /// 入口
    public func setup(datalist: [MarkillerItem]) {
        
    }
    
    /// 出口
    public func saveResult() -> [MarkillerItem] {
        outputWholeParaList()
        return paragraphList
    }
}



// MARK: OVERWRITE
extension MarkillerEditor {
    
    // CURSOR MOVE + SELECT
    public override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        originalRect.size.height = (font!.lineHeight <= 0.2) ? kMarkillerItemDefaultFontSize + 2 : font!.lineHeight + 2;
        originalRect.size.width = 5
        return originalRect
    }
    
    // CURSOR moving
    public override var selectedRange: NSRange {
        didSet {
            
        }
    }
        
    public override var canBecomeFirstResponder: Bool {
        get {
//            [self.toolBar refresh] ;
//            self.inputAccessoryView = self.toolBar ;
// Redraw in case enabbled features have changes
            return super.canBecomeFirstResponder
        }
    }
    
    // MARK: TEXTVIEW delegagte
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print("🐒\(text)")
        
        if let aItem = currentTypingItem {
            aItem.contentString.append(text)
        } else {
            currentTypingItem = MarkillerItem();
            currentTypingItem!.contentString.append(text)
        }
                        
        if text == "\n" {
            // SAVE a OUTPUT DATA
            outputWholeParaList()
            return true
        }
        
        if text == " " {
            // TODO: 确认段落格式
            
            return true
        }

        
        return true
    }


    
    /// 输出到全部
    private func outputWholeParaList () {
        if let aItem = currentTypingItem {
            paragraphList.append(aItem)
            currentTypingItem = nil
        }
    }
    
    // 设置当前编辑中文字的 段落样式
    func setParagraphFormatForCurrentTypingString() {
        if currentTypingItem?.contentString == "# " {
            currentTypingItem?.paragraphType = .headers
            currentTypingItem?.contentString = ""
        }
        
    }
    
    // 局部渲染最后一段
    func renderFomart() {
        
    }
}



