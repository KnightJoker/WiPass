//
//  KJAddController.swift
//  WiPassword
//
//  Created by Huni on 30/08/2017.
//  Copyright © 2017 KnighhtJoker. All rights reserved.
//

import UIKit


class KJAddController: UIViewController {
    
    @objc let tableView = UITableView.init(frame: CGRect(x:0,y:0,width:0,height:0), style: UITableViewStyle.grouped)
    var defaultPassBox = KJPasswordBox()
    @objc var isOn =  false
    @objc var password = String()
    @objc var surePass = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initNavigationBar()
    }

    // MARK: - init View
    
    @objc func initNavigationBar() {
        self.navigationItem.title = "新建卡片"
        let backItem = UIBarButtonItem(image:UIImage(named:"ic_back_gray"), style:UIBarButtonItemStyle.plain, target:self, action:#selector(backButtonDidClicked))
        backItem.tintColor = kTextNormalColor
        let sureItem = UIBarButtonItem(image:UIImage(named:"ic_sure_green"), style:UIBarButtonItemStyle.plain, target:self, action:#selector(sureButtonDidClicked))
        sureItem.tintColor = kThemeGreenColor
        
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationItem.rightBarButtonItem = sureItem
        
    }
    
    @objc func setupView() {
      
        tableView.backgroundColor = kThemeBackgroundColor
        tableView.register(KJAddRoutineCell.self,forCellReuseIdentifier: addRoutineCellIdentifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    // MARK: - events
    
    @objc func backButtonDidClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sureButtonDidClicked() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAddEditEndNotification), object: nil)
        
        if password == surePass {
            defaultPassBox.password = password
            
            if defaultPassBox.title == "" {
                defaultPassBox.title = "账户信息"
            }
            KJSecurityKit.shared.addPasswordBox(Password: defaultPassBox)
        } else {
            print("错误")
        }
//        print("确定")
    }
}

extension KJAddController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else {
            
            guard isOn else {
                return 2
            }
            return 3
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = KJAddRoutineCell.init(style: UITableViewCellStyle.default, reuseIdentifier: addRoutineCellIdentifier)

        if indexPath.section == 0 {
            
            cell.configCell(Type: KJAddRoutineCellType.imageHeaderCell, Title: "")
            cell.textFieldClosure = {[weak self] (text) -> Void in
                self?.defaultPassBox.title = text
            }
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
            cell.configCell(Type: KJAddRoutineCellType.defaultCell, Title: "用户名")
            cell.setTextField(Text: defaultPassBox.username, PlaceHolder: "请输入用户名")
            cell.textFieldClosure = {[weak self] (text) -> Void in
                self?.defaultPassBox.username = text
            }
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            
            cell.configCell(Type: KJAddRoutineCellType.defaultCell, Title: "密码")
            cell.setTextField(Text: defaultPassBox.password, PlaceHolder: "请输入密码")
            cell.textFieldClosure = {[weak self] (text) -> Void in
                self?.password = text
            }
            
        } else if indexPath.section == 1 && indexPath.row == 2 {
            
            cell.configCell(Type: KJAddRoutineCellType.defaultCell, Title: "确认密码")
            cell.setTextField(Text: defaultPassBox.password, PlaceHolder: "请再次输入密码")
            cell.textFieldClosure = {[weak self] (text) -> Void in
                self?.surePass = text
            }
            
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
            cell.switchIsOn = isOn
            cell.configCell(Type: KJAddRoutineCellType.switchCell, Title: "随机密码")
            cell.switchClosure = { [weak self] (isOn) -> Void in
                self?.isOn = isOn
                self?.tableView.reloadData()
            }

        } else if indexPath.section == 2 && indexPath.row == 1 && isOn == true {
            
            cell.configCell(Type: KJAddRoutineCellType.sliderCell, Title: "密码长度")
            cell.sliderClosure = { [weak self] (value) -> Void in
                self?.defaultPassBox.password = value
                self?.password = value
                self?.surePass = value
                let indexPath = IndexPath(item: 1, section: 1)
                let indexPath1 = IndexPath(item: 2, section: 1)
                self?.tableView.reloadRows(at: [indexPath,indexPath1], with: .none)
            }
            
        } else {
            
            cell.configCell(Type: KJAddRoutineCellType.remarkCell, Title: "备注")
        }
        
        return cell
    }
}

extension KJAddController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 14.0
        }
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75.0
        } else if indexPath.section == 2 && indexPath.row == 1 && isOn == false {
            return 80.0
        } else if indexPath.section == 2 && indexPath.row == 2 && isOn == true {
            return 80.0
        }
        return 50.0
    }

}











