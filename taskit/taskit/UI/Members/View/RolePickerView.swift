//
//  RolePickerView.swift
//  taskit
//
//  Created by xieran on 2018/8/14.
//  Copyright © 2018年 Snow. All rights reserved.
//

import UIKit

class RolePickerView: UIView {
    var roles: [String]?
    var selectedIndex = 0
    var selection: String? {
        didSet {
            selectedIndex = roles?.index(of: selection ?? "") ?? 0
        }
    }
    var selectBlock: ((_ role: String?) -> Void)?
    lazy var picker: UIPickerView = {
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        p.backgroundColor = .white
        return p
    }()
    
    lazy var doneBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(TaskitColor.button, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(done), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(TaskitColor.button, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = (UIApplication.shared.keyWindow?.frame)!
        
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let bar = UIButton(type: .custom)
        bar.backgroundColor = .white
        addSubview(bar)
        bar.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-200)
            make.left.right.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bar.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(40)
        }
        
        bar.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(60)
        }
        
        addSubview(picker)
        picker.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(bar.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    @objc func cancel() {
        self.removeFromSuperview()
    }
    
    @objc func done() {
        self.removeFromSuperview()
        selectBlock?(roles?[selectedIndex])
    }
}

extension RolePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
}
