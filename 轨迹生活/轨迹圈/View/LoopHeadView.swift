//
//  LoopHeadView.swift
//  轨迹生活
//
//  Created by home on 2020/2/17.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class LoopHeadView: UIView {
    
    var backImageV : UIImageView!
    var iconImageV : UIImageView!
    var label : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backImageV = UIImageView()
        self.addSubview(backImageV)
        backImageV.tag = 1
        
        iconImageV = UIImageView()
        self.addSubview(iconImageV)
        iconImageV.tag = 2
        
        label = UILabel()
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backImageV.frame = CGRect(x: 0, y: 0, width: 414, height: 248)
        backImageV.image = UIImage(named: "背景")
        iconImageV.frame = CGRect(x: 157, y: 184, width: 100, height: 100)
        iconImageV.image = UIImage(named: "头像0")
        iconImageV.layer.cornerRadius = 50
        iconImageV.layer.masksToBounds = true
        label.frame = CGRect(x: 260, y: 268, width: 100, height: 20)
        label.text = "陌上人如玉"
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
