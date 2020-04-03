//
//  LPLStockTableViewController.swift
//  轨迹生活
//
//  Created by home on 2020/2/6.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class LPLStockTableViewController: UITableViewController, EditLocationDelegate{
    
    var index : Int = 0
    //预览图片
    var coverView : UIView?
    //文件数组
    var stringArr : Array<String> = Array()
    
    var imageArr : NSMutableArray = {
        let path : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        let fullP : String = path.appendingPathComponent("image.plist")
        
        var arr : NSMutableArray
        
        if FileManager.default.fileExists(atPath: fullP){
            arr = NSMutableArray(contentsOfFile: fullP)!
        }else{
            arr = NSMutableArray()
        }
        
        
        
        return arr
    }()

    lazy var array : Array<StockItem> = {
        
        let path = Bundle.main.path(forResource: "Stock", ofType: "plist")
        let arr = NSArray(contentsOfFile: path!)
        
        var tempArr : Array<StockItem> = Array()
        var dict : [String:Any] = Dictionary()
        for dict in arr!{
            let item : StockItem = StockItem.itemWithDict(dict: dict as! [String : Any])
            tempArr.append(item)
        }
        
        return tempArr
    }()
    //仓库数据数组
    var locationArr : Array<LocationItem> = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.backgroundColor = UIColor.orange
        //底部内边距
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.tableView.register(StockTableViewCell.classForCoder(), forCellReuseIdentifier: "stock")
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageClick(notification:)), name: Notification.Name.init("imageV1Click"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(imageClick(notification:)), name: Notification.Name.init("imageV2Click"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(imageClick(notification:)), name: Notification.Name.init("imageV3Click"), object: nil)
    }
    
    @objc func imageClick(notification : Notification){
        let image = notification.userInfo!["image"]
        
        let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let imageV : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        imageV.image = image as? UIImage
        imageV.center = self.view.center
        
        //按照图片原比例展示，不会被拉伸变形
        imageV.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(coverViewTap))
        view.addGestureRecognizer(tap)
        
        view.addSubview(imageV)
        self.coverView = view
        //添加按钮
        self.setUpBtns()
        
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    func setUpBtns(){
        let btn1 : UIButton = UIButton()
//        let btn2 : UIButton = UIButton()
        
        let btnWH : CGFloat = 25
        let bottomSpace : CGFloat = 30
        
        
        btn1.frame = CGRect(x: (self.view.frame.size.width - btnWH)/2, y: (self.coverView?.frame.size.height)! - btnWH - bottomSpace, width: btnWH, height: btnWH)
//        btn2.frame = CGRect(x: (self.coverView?.frame.size.width)! - rlSpace - btnWH, y: (self.coverView?.frame.size.height)! - btnWH - bottomSpace, width: btnWH, height: btnWH)
        //
        btn1.setImage(UIImage(named: "垃圾桶"), for: .normal)
        
        //添加按钮
        self.coverView?.addSubview(btn1)
//        self.coverView?.addSubview(btn2)
        
        
    }
    
    @objc func coverViewTap(){
        self.coverView?.removeFromSuperview()
        self.coverView = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("arrCount:",self.array.count)
        return self.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StockTableViewCell(style: .default, reuseIdentifier: "stock")

        cell.item = self.array[indexPath.row]
        if indexPath.row == 0{
            //图片数小于两张，传入数据数组，遍历取图
//            if self.locationArr[indexPath.row].imageCount! < 2{
                cell.array = self.locationArr
                cell.locationItem = self.locationArr[indexPath.row]
            
//            }else{
//                cell.locationItem = self.locationArr[indexPath.row]
        }else if indexPath.row == 1{
            cell.imageArr = self.imageArr
        }
//        }else{
//            cell.locationItem = self.locationArr[indexPath.row]
//        }
//
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = self.array[indexPath.row]
        
        return item.cellHeight!
    }

    func imageAndText(index : Int, arr : Array<LocationItem>) {
        
//        var path : String!
//        let path1 : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
//        let fullPath : String = path1.appendingPathComponent("place.plist")
//        let isExists = FileManager.default.fileExists(atPath: fullPath)
//        if isExists == true {
//            path = fullPath
//        }else{
//            //读取plist文件
//            path = Bundle.main.path(forResource: "Location", ofType: "plist")
//        }
//
//        let tempArray:Array<[String:Any]>! = NSArray(contentsOfFile: path) as? Array<[String:Any]>
//        var arr = Array<LocationItem>()
//        for locationDict in tempArray{
//            let item:LocationItem = LocationItem.locationWithDict(dict: locationDict)
//            arr.append(item)
//        }
        
        self.locationArr = arr
        self.index = index
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
