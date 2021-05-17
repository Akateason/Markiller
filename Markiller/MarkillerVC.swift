//
//  MarkillerVC.swift
//  Markiller
//
//  Created by teason23 on 2021/5/18.
//

import Foundation
import UIKit
import SnapKit

class MarkillerVC: UIViewController {
    
    var markiller: MarkillerEditor = MarkillerEditor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(markiller)
        markiller.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        markiller.backgroundColor = UIColor.xt_pondWater()
        markiller.becomeFirstResponder()                        
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
