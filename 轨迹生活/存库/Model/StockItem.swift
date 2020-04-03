//
//  StockItem.swift
//  轨迹生活
//
//  Created by home on 2020/3/4.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class StockItem: NSObject {

    var iconName : String!
    var title : String!
    var imageCount : CGFloat!
    var imageW : CGFloat!
    var imageH : CGFloat!
    var iconImageWH : CGFloat!
    var isLabel : String!
    
    var cellHeight1 : CGFloat?
    var cellHeight : CGFloat?{
        get{
            if cellHeight1 == nil{
                
                let space : CGFloat = self.isLabel == "0" ? (30+10+20) : (30+10+20+30)
                let iconH = CGFloat.init(exactly: self.iconImageWH)
                let imageH = CGFloat.init(exactly: self.imageH)
                
                cellHeight1 = space + iconH! + imageH!
            }
            return cellHeight1
        }
        
    }
    
    class func itemWithDict(dict : [String : Any]) ->(StockItem){
        
        let item : StockItem = StockItem()
        item.iconName = dict["iconName"] as? String
        item.title = dict["title"] as? String
        item.imageCount = CGFloat.init(exactly: dict["imageCount"] as! NSNumber)
        item.imageW = CGFloat.init(exactly: dict["imageW"] as! NSNumber)
        item.imageH = CGFloat.init(exactly: dict["imageH"] as! NSNumber)
        item.iconImageWH = CGFloat.init(exactly: dict["iconImageWH"] as! NSNumber)
        item.isLabel = dict["isLabel"] as? String
        
        return item
    }
}
