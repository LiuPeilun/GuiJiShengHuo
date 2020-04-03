//
//  StockTableViewCell.swift
//  轨迹生活
//
//  Created by home on 2020/3/4.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    var item : StockItem!
    var locationItem : LocationItem!{
        didSet{
            //模型中图片数
            let count = self.locationItem.imageCount!
            self.setUpImage(count: count)
        }
    }
    //图片数组
    var imageArr : NSMutableArray! {
        didSet{
            //数组取图片
            if self.imageArr.count >= 2{
                let image1 = UIImage.init(data: self.imageArr[self.imageArr.count-1] as! Data)
                self.imageV1.setBackgroundImage(image1, for: .normal)
                
                let image2 = UIImage.init(data: self.imageArr[self.imageArr.count-2] as! Data)
                self.imageV2.setBackgroundImage(image2, for: .normal)
                
                if self.imageArr.count >= 3{
                    let image3 = UIImage.init(data: self.imageArr[self.imageArr.count-3] as! Data)
                    self.imageV3.setBackgroundImage(image3, for: .normal)
                }
            }else if self.imageArr.count == 1{
                let image1 = UIImage.init(data: self.imageArr[self.imageArr.count-1] as! Data)
                self.imageV1.setBackgroundImage(image1, for: .normal)
            }
        }
    }
    
    var array : Array<LocationItem>? = {
        var path : String!
        let path1 : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        let fullPath : String = path1.appendingPathComponent("place.plist")
        let isExists = FileManager.default.fileExists(atPath: fullPath)
        if isExists == true {
            path = fullPath
        }else{
            //读取plist文件
            path = Bundle.main.path(forResource: "Location", ofType: "plist")
        }

        let tempArray:Array<[String:Any]>! = NSArray(contentsOfFile: path) as? Array<[String:Any]>
        var arr = Array<LocationItem>()
        for locationDict in tempArray{
            let item:LocationItem = LocationItem.locationWithDict(dict: locationDict)
            arr.append(item)
        }

        return arr
    }()
    
    var iconImageV : UIImageView!
    var titleL : UILabel!
    var imageV1 : UIButton!
    var imageV2 : UIButton!
    var imageV3 : UIButton!
    var label1 : UILabel?
    var label2 : UILabel?
    var label3 : UILabel?
    
    func setUpImage(count : Int) {
        var i = 0
        if count == 3{
            self.imageV1.setBackgroundImage(UIImage.init(data: self.locationItem.imageData3!), for: .normal)
            self.imageV2.setBackgroundImage(UIImage.init(data: self.locationItem.imageData2!), for: .normal)
        }else if count == 2{
            self.imageV1.setBackgroundImage(UIImage.init(data: self.locationItem.imageData2!), for: .normal)
            self.imageV2.setBackgroundImage(UIImage.init(data: self.locationItem.imageData1!), for: .normal)
        }else if count == 1{
            self.imageV1.setBackgroundImage(UIImage.init(data: self.locationItem.imageData1!), for: .normal)
            while true {
                if(i==self.array?.count){
                    break
                }
                let item = self.array![i]
                if item.imageCount! > 0{
                    self.imageV2.setBackgroundImage(UIImage.init(data: self.locationItem.imageData1!), for: .normal)
                    break
                }
                i = i + 1
            }
            
        }else if count == 0{
            
            while true {
    
                if(i==self.array?.count){
                    break
                }
                
                let item = self.array![i]
                
                if item.imageCount! == 1 {
                    if self.imageV1.currentBackgroundImage == nil{
//                        let image = UIImage.init(data: self.locationItem.imageData1!)
                            
                        self.imageV1.setBackgroundImage(UIImage.init(data: self.locationItem.imageData1!), for: .normal)
                        continue
                    }else if self.imageV2.currentBackgroundImage == nil{
                        self.imageV2.setBackgroundImage(UIImage.init(data: self.locationItem.imageData1!), for: .normal)
                        break
                    }
                    
                }else if item.imageCount! >= 2{
                    
                    print("item.imageCount = ",item.imageCount as Any)
                    
                    self.imageV1.setBackgroundImage(UIImage.init(data: self.locationItem.imageData2!), for: .normal)
                    self.imageV2.setBackgroundImage(UIImage.init(data: self.locationItem.imageData1!), for: .normal)
                    break
                }
                
                i = i+1
            }
        }
        
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let iconImageV = UIImageView()
        self.iconImageV = iconImageV
        self.contentView.addSubview(iconImageV)
        
        let titleL = UILabel()
        self.titleL = titleL
        self.contentView.addSubview(titleL)
        
        let imageV1 = UIButton()
        self.contentView.addSubview(imageV1)
        imageV1.addTarget(self, action: #selector(imageClick1(btn:)), for: .touchUpInside)
        self.imageV1 = imageV1
        
        let imageV2 = UIButton()
        self.contentView.addSubview(imageV2)
        imageV2.addTarget(self, action: #selector(imageClick2(btn:)), for: .touchUpInside)
        self.imageV2 = imageV2
        
        let imageV3 = UIButton()
        self.contentView.addSubview(imageV3)
        imageV3.addTarget(self, action: #selector(imageClick3(btn:)), for: .touchUpInside)
        self.imageV3 = imageV3
        
        let label1 = UILabel()
        self.contentView.addSubview(label1)
        self.label1 = label1
        
        let label2 = UILabel()
        self.contentView.addSubview(label2)
        self.label2 = label2
        
        let label3 = UILabel()
        self.contentView.addSubview(label3)
        self.label3 = label3
        
    }
    
    @objc func imageClick1(btn : UIButton){
        let image = btn.currentBackgroundImage
        NotificationCenter.default.post(name: .init("imageV1Click"), object: self, userInfo: ["image" : image as Any])
    }

    @objc func imageClick2(btn : UIButton){
        let image = btn.currentBackgroundImage
        NotificationCenter.default.post(name: .init("imageV2Click"), object: self, userInfo: ["image" : image as Any])
    }
    
    @objc func imageClick3(btn : UIButton){
        let image = btn.currentBackgroundImage
        NotificationCenter.default.post(name: .init("imageV3Click"), object: self, userInfo: ["image" : image as Any])
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
    
    override func layoutSubviews() {
        
        self.iconImageV.frame = CGRect(x: 3, y: 30, width: self.item.iconImageWH, height: self.item.iconImageWH)
        self.iconImageV.image = UIImage(named: self.item.iconName)
        
        let y = self.iconImageV.frame.origin.y + self.iconImageV.frame.size.height + 10
        
        self.titleL.frame = CGRect(x: 48, y: 45, width: 60, height: 25)
        self.titleL.text = self.item.title
        
        if self.item.imageCount == 2 {
            self.imageV1.frame = CGRect(x: 0, y: 85, width: self.item.imageW, height: self.item.imageH)
            self.imageV1.backgroundColor = UIColor.lightGray
            self.imageV2.frame = CGRect(x: self.item.imageW + 2, y: 85, width: self.item.imageW, height: self.item.imageH)
            self.imageV2.backgroundColor = UIColor.lightGray
        }else if self.item.imageCount == 3{
            
            let space = (self.frame.size.width/3 - self.item.imageW)/2
            let spaceL = (self.frame.size.width/3 - 80)/2
            
            self.imageV1.frame = CGRect(x: space, y: y, width: self.item.imageW, height: self.item.imageH)
            self.imageV1.backgroundColor = UIColor.lightGray
            
            self.imageV2.frame = CGRect(x:self.frame.size.width/3 + space, y: y, width: self.item.imageW, height: self.item.imageH)
            self.imageV2.backgroundColor = UIColor.lightGray
            
            self.imageV3.frame = CGRect(x: 2 * self.frame.size.width/3 + space, y: y, width: self.item.imageW, height: self.item.imageH)
            self.imageV3.backgroundColor = UIColor.lightGray
            
            if(self.item.isLabel == "1"){
                self.label1!.frame = CGRect(x: spaceL, y: self.imageV1.frame.origin.y + self.imageV1.frame.size.height + 10, width: 80, height: 20)
                self.label1!.backgroundColor = UIColor.lightGray
                
                self.label2!.frame = CGRect(x: self.frame.size.width/3 + spaceL, y: self.imageV1.frame.origin.y + self.imageV1.frame.size.height + 10, width: 80, height: 20)
                self.label2!.backgroundColor = UIColor.lightGray
                
                self.label3!.frame = CGRect(x: 2 * self.frame.size.width/3 + spaceL, y: self.imageV1.frame.origin.y + self.imageV1.frame.size.height + 10, width: 80, height: 20)
                self.label3!.backgroundColor = UIColor.lightGray
            }
        }
    }

}
