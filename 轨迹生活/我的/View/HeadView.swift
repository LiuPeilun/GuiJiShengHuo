//
//  HeadView.swift
//  轨迹生活
//
//  Created by home on 2020/2/7.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class HeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //头像
    var imageV : UIImageView!
    //昵称
    var label : UILabel!
    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: "head")
//
//        imageV = UIImageView()
//        label = UILabel()
//
//        self.addSubview(imageV)
//        self.addSubview(label)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageV = UIImageView()
        label = UILabel()

        self.addSubview(imageV)
        self.addSubview(label)
    }
    
    //xib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //布局子控件
    override func layoutSubviews() {
        
        imageV.frame = CGRect(x: 10, y: 28, width: 90, height: 90)
        imageV.layer.cornerRadius = imageV.frame.size.width/2
        imageV.layer.masksToBounds = true
        imageV.image = UIImage(named: "女孩头像")
        
        label.frame = CGRect(x: 114, y: 53, width: 100, height: 24)
        label.text = "陌上人如玉"
        
    }
}
