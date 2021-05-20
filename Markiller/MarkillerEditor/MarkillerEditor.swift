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

public class MarkillerEditor: UITextView, UITextViewDelegate {
    let kMKEditor_FlexValue:CGFloat = 30.0
    let kMKEditor_FontSize:CGFloat = 16.0
    var currentTypingString = ""
    var paragraphList = [MarkillerItem]()
    
    // MARK: PUBLIC
    
    /// 入口
    public func setup(datalist: [MarkillerItem]) {
        
    }
    
    /// 出口
    public func saveResult() -> [MarkillerItem] {
        outputWholeParaList(item: catchLastTypingSentence())
        return paragraphList
    }
    
    // MARK: LIFE
    
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
        font = UIFont.systemFont(ofSize: kMKEditor_FontSize)
        keyboardDismissMode = .onDrag
        delegate = self
        smartDashesType = .no
    }
    
    // MARK: OVERWRITE
    
    // CURSOR MOVE + SELECT
    public override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        originalRect.size.height = (font!.lineHeight <= 0.2) ? kMKEditor_FontSize + 2 : font!.lineHeight + 2;
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
            //    [self.toolBar refresh] ;
            //    self.inputAccessoryView = self.toolBar ;
                // Redraw in case enabbled features have changes
            return super.canBecomeFirstResponder
        }
    }
    
    // MARK: TEXTVIEW delegagte
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("🐒\(text)")
        currentTypingString.append(text)
        
        if text == " " {
            // TODO: 确认段落格式
            if currentTypingString == "# " {
                // RENDER
                //...
            }
            return true
        }
        
        if text == "\n" {
            // SAVE a OUTPUT DATA
            outputWholeParaList(item: catchLastTypingSentence())
            return true
        }
        
        return true
    }

    /// 拿到断句的最后一句话
    private func catchLastTypingSentence () -> MarkillerItem? {
        guard currentTypingString.isEmpty == false else {
            return nil
        }
        let aItem = MarkillerItem()
        aItem.contentString = currentTypingString;
        return aItem
    }
    
    /// 输出到全部
    private func outputWholeParaList (item: MarkillerItem?) {
        if let aItem = item {
            paragraphList.append(aItem)
            currentTypingString = ""
        }
    }
    
}
