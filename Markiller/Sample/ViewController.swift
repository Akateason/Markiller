//
//  ViewController.swift
//  Markiller
//
//  Created by teason23 on 2021/5/18.
//

import UIKit
import XTlib
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let table: UITableView = UITableView()
    let datas =  ["z_head","z_block","z_paragraph","z_inline","z_all"]
    
            
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "zample"
        
        table.xt_setup()
        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalTo(view);
        }
        
        ZampleCell.xt_registerCls(fromTable: table)
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ZampleCell.xt_fetch(fromTable: table, indexPath: indexPath)!
        cell.xt_configure(datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:MarkillerVC = MarkillerVC()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

