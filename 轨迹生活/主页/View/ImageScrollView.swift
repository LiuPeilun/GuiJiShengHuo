//
//  ImageScrollView.swift
//  轨迹生活
//
//  Created by home on 2020/2/10.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView {
/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //轮播图片
    var imageV1 : UIImageView!
    var imageV2 : UIImageView!
    var imageV3 : UIImageView!
    
    //初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageV1 = UIImageView()
        imageV1.backgroundColor = UIColor.red
        imageV2 = UIImageView()
        imageV2.backgroundColor = UIColor.black
        imageV3 = UIImageView()
        imageV3.backgroundColor = UIColor.systemPink
        
        self.addSubview(imageV1)
        self.addSubview(imageV2)
        self.addSubview(imageV3)
    }
    
    //xib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageV1.image = UIImage(named: "轮播1")
        imageV2.image = UIImage(named: "轮播2")
        imageV3.image = UIImage(named: "轮播3")
        
        imageV1.frame = CGRect(x: 0, y: 0, width: 414, height: 200)
        imageV2.frame = CGRect(x: self.frame.size.width, y: 0, width: 414, height: 200)
        imageV3.frame = CGRect(x: self.frame.size.width * 2, y: 0, width: 414, height: 200)
        
    }

}
