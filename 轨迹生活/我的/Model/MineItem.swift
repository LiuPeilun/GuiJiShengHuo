//
//  MineItem.swift
//  轨迹生活
//
//  Created by home on 2020/2/15.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class MineItem: NSObject {
    var iconName : String?
    var title : String?
    
    class func mineWithDict(dict : [String:Any]) -> (MineItem){
        
        let item = MineItem()
        
        item.iconName = dict["iconName"] as? String
        item.title = dict["title"] as? String
        
        return item
        
    }
}
