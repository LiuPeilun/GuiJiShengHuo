//
//  LocationItem.swift
//  轨迹生活
//
//  Created by home on 2020/2/14.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class LocationItem: NSObject {

    //图标名
    var iconName:String?
    //地点名
    var placeName:String?
    //图片数量
    var imageCount:Int?
    //图片data1
    var imageData1:Data?
    //图片data2
    var imageData2:Data?
    //图片data3
    var imageData3:Data?
    //文字内容
    var string:String?
    
    //字典转模型方法
    class func locationWithDict(dict:Dictionary<String, Any>) -> (LocationItem){
        
        let item = LocationItem()
        
        item.iconName = dict["iconName"] as? String
        item.placeName = dict["placeName"] as? String
        item.imageCount = Int.init(exactly: dict["imageCount"] as! NSNumber)
        item.string = dict["string"] as? String
        
        if item.imageCount == 0 {
            
        }else if item.imageCount == 1{
            item.imageData1 = dict["imageData1"] as? Data
        }else if item.imageCount == 2{
            item.imageData1 = dict["imageData1"] as? Data
            item.imageData2 = dict["imageData2"] as? Data
        }else if item.imageCount == 3{
            item.imageData1 = dict["imageData1"] as? Data
            item.imageData2 = dict["imageData2"] as? Data
            item.imageData3 = dict["imageData3"] as? Data
        }
        
        return item
    }
    
    
}
