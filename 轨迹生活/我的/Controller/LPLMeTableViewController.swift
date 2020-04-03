//
//  LPLMeTableViewController.swift
//  轨迹生活
//
//  Created by home on 2020/2/6.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class LPLMeTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //模型数组
    lazy var array : Array<MineItem> = {
        
        var path : String? = Bundle.main.path(forResource: "Mine", ofType: "plist")
        var arr : Array<[String:String]>? = (NSArray(contentsOfFile: path!) as? Array<[String:String]>)
        
//        print(arr as Any)
        
        var tempArray = Array<MineItem>()
        var dict = Dictionary<String, Any>()
        for dict in arr!{
            var item = MineItem.mineWithDict(dict: dict)
            tempArray.append(item)
            
            print(dict)
            
        }
//        print(tempArray)
        
        return tempArray
    }()
    
    //图片选择器
    lazy var pickVC : UIImagePickerController = {
        
        let pickVC = UIImagePickerController()
        pickVC.delegate = self
        //允许拍照后进行编辑
        pickVC.allowsEditing = true
        
        return pickVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.sectionHeaderHeight = 20
        self.tableView.register(UINib(nibName: "LPLMeTableViewCell", bundle: nil), forCellReuseIdentifier: "lpl")
        
        //禁止滚动
        self.tableView.isScrollEnabled = false
        
        self.setUpHeadView()
       
    }

    //创建tableView头视图
    func setUpHeadView(){
        let headView = HeadView(frame: CGRect(x: 0, y: 0, width: 414, height: 146))
        headView.backgroundColor = UIColor.white
        self.tableView.tableHeaderView = headView
    }
//     MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 2
        }else{
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lpl", for: indexPath) as! LPLMeTableViewCell

        if indexPath.section == 0{
            cell.item = array[indexPath.row]
        }else{
            cell.item = array[indexPath.section + 1]
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //修改头像
            if indexPath.row == 0 {
                let alertVC : UIAlertController = UIAlertController(title: "修改头像", message: "您要通过哪种方式修改？", preferredStyle: UIAlertController.Style.actionSheet)
                
                alertVC.addAction(UIAlertAction(title: "相机", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    //开启相机
                    self.openCamera()
                }))
                
                alertVC.addAction(UIAlertAction(title: "相册", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    //开启相册
                    self.openPhotoLibrary()
                }))
                
                alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
                
                self.present(alertVC, animated: true, completion: nil)
                //昵称修改
            }else if indexPath.row == 1 {
                
            }
        }
    }
    
    //开启相机
    func openCamera() {
        //判断相机是否可用
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //设置操作为拍照
            pickVC.sourceType = .camera
            self.present(pickVC, animated: true, completion: nil)
        }else{
            let alertVC : UIAlertController = UIAlertController(title: "对不起", message: "没有相机权限", preferredStyle: .actionSheet)
            
            alertVC.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //开启相册
    func openPhotoLibrary() {
        //设置操作为访问相册
        pickVC.sourceType = .photoLibrary
        pickVC.allowsEditing = true
        
        self.present(pickVC, animated: true, completion: nil)
    }
    
    //  MARK: - UIImagePickerControllerDelegate
    //完成选择回调方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //判断选中媒体类型
        if let typeStr : String = info[UIImagePickerController.InfoKey.mediaType] as? String{
            //图片
            if typeStr == "public.image" {
                //图片有值
                if var image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    //修改成合适的大小
                    //设置新尺寸
                    let imageSize = CGSize(width: 100, height: 100)
                    //开启图片上下文，编辑图片
                    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
                    //修改尺寸
                    image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
                    //生成修改后的新图片
                    image = UIGraphicsGetImageFromCurrentImageContext()!
                    //关闭图片上下文，结束编辑
                    UIGraphicsEndImageContext()
                    
                    //修改头像
                    for imageV in self.tableView.tableHeaderView!.subviews {
                        if imageV.isKind(of: UIImageView.classForCoder()){
                            (imageV as! UIImageView).image = image
                        }
                    }
                    
                    //发送通知更换头像
                    NotificationCenter.default.post(name: Notification.Name.init("changeHeadImage"), object: self, userInfo: ["image" : image])
                    
                }
            }
            
        }else{//如果类型返回为空，则选择失败
            print("选择图片失败！")
        }
        picker.dismiss(animated: true, completion: nil)
//        print("type : ", info[UIImagePickerController.InfoKey.mediaType] as Any)
    }
    
    //取消选择图片
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
