//
//  TrajectoryLoopItem.swift
//  轨迹生活
//
//  Created by home on 2020/2/17.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class TrajectoryLoopItem: NSObject {

    var iconName : String!
    var name : String!
    var imageCount : NSNumber!
    var title : String!
    var imageW : NSNumber!
    var imageH : NSNumber!
    var imageName : String!
    var labelRows : NSNumber!
    var labelH : NSNumber!
    var iconWH : NSNumber!
    
    var imageName2 : String?
    var imageW2 : NSNumber?
    var imageH2 : NSNumber?
    
    var cellHeight1 : CGFloat?
    var cellHeight : CGFloat?{
        get{
            if cellHeight1 == nil {
                let icon = CGFloat.init(Float.init(exactly: self.iconWH)!)
                let label = CGFloat.init(Float.init(exactly: self.labelRows)!) * CGFloat.init(Float.init(exactly: self.labelH)!)
                let image = CGFloat.init(Float.init(exactly: self.imageH)!)
                
                cellHeight1 = 35 + icon + label + 20 + image

                
            }
            return cellHeight1
        }
    }
    
    class func dataWithDict(dict : [String : Any]) -> TrajectoryLoopItem {
        let item = TrajectoryLoopItem()
        
        //一张图
        if dict["imageCount"] as! NSNumber == NSNumber(integerLiteral: 1) {
            item.iconName = dict["iconName"] as? String
            item.name = dict["name"] as? String
            item.title = dict["title"] as? String
            item.imageW = dict["imageW"] as? NSNumber
            item.imageH = dict["imageH"] as? NSNumber
            item.imageName = dict["imageName"] as? String
            item.imageCount = dict["imageCount"] as? NSNumber
            item.labelH = dict["labelH"] as? NSNumber
            item.labelRows = dict["labelRows"] as? NSNumber
            item.iconWH = dict["iconWH"] as? NSNumber
        }else{//两张图
            item.iconName = dict["iconName"] as? String
            item.name = dict["name"] as? String
            item.title = dict["title"] as? String
            item.imageW = dict["imageW"] as? NSNumber
            item.imageH = dict["imageH"] as? NSNumber
            item.imageName = dict["imageName"] as? String
            item.imageCount = dict["imageCount"] as? NSNumber
            item.labelH = dict["labelH"] as? NSNumber
            item.labelRows = dict["labelRows"] as? NSNumber
            item.imageName2 = dict["imageName2"] as? String
            item.imageW2 = dict["imageW2"] as? NSNumber
            item.imageH2 = dict["imageH2"] as? NSNumber
            item.iconWH = dict["iconWH"] as? NSNumber
        }
        
        return item
    }
}
