//
//  TrajectoryLoopCell.swift
//  轨迹生活
//
//  Created by home on 2020/2/17.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class TrajectoryLoopCell: UITableViewCell {
    
    //头像
    var iconImageV : UIImageView!
    //名字
    var label : UILabel!
    //文字内容
    var title : UILabel!
    //图片内容
    var imageV1 : UIImageView!
    var imageV2 : UIImageView!

    var item : TrajectoryLoopItem!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "loopCell")
        
        iconImageV = UIImageView()
        self.contentView.addSubview(iconImageV)
        
        label = UILabel()
        self.contentView.addSubview(label)
        
        title = UILabel()
        self.contentView.addSubview(title)
        
        imageV1 = UIImageView()
        self.contentView.addSubview(imageV1)
        imageV1.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapImageV1))
        imageV1.addGestureRecognizer(tap1)
        
        imageV2 = UIImageView()
        self.contentView.addSubview(imageV2)
        imageV2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapImageV2))
        imageV2.addGestureRecognizer(tap2)
        
        self.selectionStyle = .none
    }
    
    @objc func tapImageV1(){
        NotificationCenter.default.post(name: Notification.Name.init("image1Click"), object: self, userInfo: ["item" : self.item as TrajectoryLoopItem])
    }
    
    @objc func tapImageV2(){
        NotificationCenter.default.post(name: Notification.Name.init("image2Click"), object: self, userInfo: ["item" : self.item as TrajectoryLoopItem])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageV.frame = CGRect(x: 2, y: 36, width: CGFloat.init(exactly: self.item!.iconWH)!, height: CGFloat.init(exactly: self.item!.iconWH)!)
        //设置圆角
        iconImageV.layer.cornerRadius = 30
        iconImageV.image = UIImage(named: self.item.iconName)

        
        //0,97,156
        label.frame = CGRect(x: CGFloat.init(exactly: self.item!.iconWH)!+8, y: 56, width: 150, height: CGFloat.init(exactly: self.item!.labelH)!)
        label.text = self.item.name
        label.textColor = UIColor(red: 0/255.0, green: 97/255.0, blue: 156/255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        
        title.frame = CGRect(x: CGFloat.init(exactly: self.item!.iconWH)!+8, y: 96, width: self.contentView.frame.size.width - 68, height: CGFloat.init(exactly: self.item!.labelH)! * CGFloat.init(exactly: self.item.labelRows)! + 10)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 0
        //设置行距
        let text=NSMutableAttributedString.init(string: self.item.title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.length))
        title.attributedText = text
        title.font = UIFont.systemFont(ofSize: 15)
        
        //内容一张图片
        if self.item?.imageCount == 1{
            
            imageV1.frame = CGRect(x: 69, y: title.frame.origin.y + CGFloat.init(exactly: self.item.labelRows)! * CGFloat.init(exactly:self.item.labelH)! + 10, width: CGFloat.init(exactly: self.item.imageW)!, height: CGFloat.init(exactly: self.item.imageH)!)
            
            imageV1.image = UIImage(named: self.item.imageName)
            
            imageV2.isHidden = true
            
        }
        //内容两张图片
        else if self.item?.imageCount == 2{
            imageV1.frame = CGRect(x: 69, y: title.frame.origin.y + CGFloat.init(exactly: self.item.labelRows)! * CGFloat.init(exactly:self.item.labelH)! + 10, width: CGFloat.init(exactly: self.item.imageW)!, height: CGFloat.init(exactly: self.item.imageH)!)
            imageV1.image = UIImage(named: self.item.imageName)
            
            imageV2.frame = CGRect(x: imageV1.frame.origin.x + imageV1.frame.size.width + 5, y: (CGFloat.init(exactly: self.item.imageH)! - CGFloat.init(exactly: self.item.imageH2!)!)/2 + imageV1.frame.origin.y, width: CGFloat.init(exactly: self.item.imageW2!)!, height: CGFloat.init(exactly: self.item.imageH2!)!)
            imageV2.image = UIImage(named: self.item.imageName2!)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
