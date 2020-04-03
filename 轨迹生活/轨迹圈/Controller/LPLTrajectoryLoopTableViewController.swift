//
//  LPLTrajectoryLoopTableViewController.swift
//  轨迹生活
//
//  Created by home on 2020/2/6.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class LPLTrajectoryLoopTableViewController: UITableViewController {

    //遮罩
    var coverView : UIView!
    //图
    var imageV : UIImageView!
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("点击")
//    }
    //懒加载
    lazy var array : Array<TrajectoryLoopItem> = {
        
        let path = Bundle.main.path(forResource: "TrajectoryLoop", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        var dict : [String : Any] = Dictionary()
        var tempArray : [TrajectoryLoopItem] = Array()
        for dict in array!{
            let item = TrajectoryLoopItem.dataWithDict(dict: dict as! [String:Any])
            tempArray.append(item)
            
//            print(item.iconWH!)
            
        }
        
//        print("tempArray : ",tempArray)
        
        return tempArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.tableView.tableHeaderView = LoopHeadView(frame: CGRect(x: 0, y: 0, width: 414, height: 284))
        
        self.tableView.register(TrajectoryLoopCell.classForCoder(), forCellReuseIdentifier: "loopCell")
        
        //监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(image1Scale(notification:)), name: Notification.Name.init("image1Click"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(image2Scale(notification:)), name: Notification.Name.init("image2Click"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeImage(notification:)), name: Notification.Name.init("changeHeadImage"), object: nil)
    }
    
    //添加通知监听者
    class func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeImage(notification:)), name: Notification.Name.init("changeHeadImage"), object: nil)
    }
    
    //改变头像
    @objc func changeImage(notification : Notification){
        
        let image : UIImage = notification.userInfo!["image"] as! UIImage
        for headimageV in self.tableView.tableHeaderView!.subviews{
            if headimageV.isKind(of: UIImageView.classForCoder()) && headimageV.tag == 2{
                (headimageV as! UIImageView).image = image
                
            }
        }
    }

    @objc func image1Scale(notification : Notification){
//        notification.userInfo!["image1Name"]
//        print("image1Name",notification.userInfo!["image1Name"] as! String)
        
        let item : TrajectoryLoopItem = notification.userInfo!["item"] as! TrajectoryLoopItem
        
        if coverView == nil {
            coverView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
            
            
            coverView.addGestureRecognizer(tap)
            
            coverView.backgroundColor = UIColor.black
    //        self.view.addSubview(coverView)
            UIApplication.shared.keyWindow?.addSubview(coverView)
        }else{
            coverView.isHidden = false
        }
        
        imageV = UIImageView()
        let scale = 414/CGFloat.init(exactly: item.imageW)!
        imageV.image = UIImage(named: item.imageName)
        imageV.frame = CGRect(x: 0, y: 0, width: 414, height: scale * CGFloat.init(exactly: item.imageH)!)
        imageV.contentMode = .scaleAspectFill
        imageV.center = self.view.center
        print("center",self.view.center)
        
        coverView.addSubview(imageV)
        
    }
    
    @objc func tapView(){
        imageV.removeFromSuperview()
        coverView.isHidden = true;
        
    }
    
    @objc func image2Scale(notification : NSNotification){
//        print("image2Name",notification.userInfo!["image2Name"] as! String)
        let item : TrajectoryLoopItem = notification.userInfo!["item"] as! TrajectoryLoopItem
            
        if coverView == nil {
            coverView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
                    
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
            
            
            coverView.addGestureRecognizer(tap)
            
            coverView.backgroundColor = UIColor.black
    //        self.view.addSubview(coverView)
            UIApplication.shared.keyWindow?.addSubview(coverView)
        }else{
            coverView.isHidden = false
        }
        
        imageV = UIImageView()
        let scale = 414/CGFloat.init(exactly: item.imageW2!)!
        imageV.image = UIImage(named: item.imageName2!)
        imageV.frame = CGRect(x: 0, y: 0, width: 414, height: scale * CGFloat.init(exactly: item.imageH2!)!)
        imageV.contentMode = .scaleAspectFill
        imageV.center = self.view.center
        print("center",self.view.center)
        
        coverView.addSubview(imageV)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print(array.count)
        return array.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrajectoryLoopCell(style: .default, reuseIdentifier: "loopCell")
        
        cell.item = array[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let item = array[indexPath.row]
//        print(item.cellHeight!)
        
        return item.cellHeight!
    }
    
    //销毁方法,oc中delloc方法
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
