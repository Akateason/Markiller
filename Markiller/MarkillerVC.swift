//
//  MarkillerVC.swift
//  Markiller
//
//  Created by teason23 on 2021/5/18.
//

import Foundation
import UIKit
import SnapKit
import YYModel

class MarkillerVC: UIViewController {
    
    var markiller: MarkillerEditor = MarkillerEditor()
    var btTest: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(markiller)
        markiller.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        markiller.backgroundColor = UIColor.xt_pondWater()
        markiller.becomeFirstResponder()
        
        btTest.setTitle("back", for: .normal)
        view.addSubview(btTest)
        btTest.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 40))
            make.right.equalTo(view)
            make.centerY.equalTo(view.centerY)
        }
        btTest.xt_(whenTapped: {
            let array: [MarkillerItem] = self.markiller.saveResult()
            let jsonString = array.toJSONString()!            
            print(jsonString)
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
