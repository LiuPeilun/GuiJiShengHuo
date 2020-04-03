//
//  LPLTrajectoryTableTableViewController.swift
//  轨迹生活
//
//  Created by home on 2020/2/6.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

protocol LPLTrajectoryDelegate : NSObjectProtocol {
    
    func locationDataItem(item : LocationItem, index : Int)
}

class LPLTrajectoryTableViewController: UITableViewController ,UITextFieldDelegate,LPLMainViewControllerDelegate{

    var headView : UIView!
    var locationStr : String?
    
    var tempLabel : UILabel!
    var weatherLabel : UILabel!
    
    static let trvVC : LPLTrajectoryTableViewController = LPLTrajectoryTableViewController()
    
    let apiId = "03bf7e5f115c85e76937f31e583a56de"
    weak var delegate : LPLTrajectoryDelegate?
    
//    var inputField = UITextField()
    var textF : String?
    
    //工程内plist文件路径
    let path : String = {
        //plist文件路径
        let path = Bundle.main.path(forResource: "Location", ofType: "plist")
        
        return path!
    }()
    
    //沙盒存储路径
    let fullPath : String = {
        let path : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        let path1 : String = path.appendingPathComponent("place.plist")
        
        return path1
    }()
    
    var array : Array<LocationItem> = {
        
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
        var locationDict = Dictionary<String, Any>()
        for locationDict in tempArray{
            var item:LocationItem = LocationItem.locationWithDict(dict: locationDict)
            arr.append(item)
        }
        
        return arr
        
    }()
    
    var tempArray : NSMutableArray = {
        
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
        
        let arr : NSMutableArray = NSMutableArray(contentsOfFile: path)!
        
        
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.inputField.addTarget(self, action: #selector(inputChange(inputField:)), for: .editingChanged)

        self.view.backgroundColor = UIColor.red
        self.tableView.backgroundColor = UIColor(red: 253/255.0, green: 252/255.0, blue: 230/255.0, alpha: 1)
        self.tableView.rowHeight = 50
        
        self.tableView.register(TrajectoryCell.classForCoder(), forCellReuseIdentifier: "trajectory")
       
        self.setUpHeadView()
        
        self.setUpDateLabel()
        
        self.setUpWeatherLabel()
        
        let operation = BlockOperation.init {
            self.setUpData()
        }
        let queue = OperationQueue.init()
        queue.addOperation(operation)
        
        
        self.setUpName()
        
        self.setUpLocation()
    }
    
    //重新加载字典中的数据
    func freshData(){
        
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
//        var locationDict = Dictionary<String, Any>()
        for locationDict in tempArray{
            let item:LocationItem = LocationItem.locationWithDict(dict: locationDict)
            arr.append(item)
        }
        
        self.array = arr
    }
    
//    @objc func inputChange(inputField : UITextField){
//        textF = inputField.text
//    }
    
    //headView
    func setUpHeadView() {
        headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 160))
        
        headView.backgroundColor = UIColor.white
        self.tableView.tableHeaderView = headView
    }
    
    //日期
    func setUpDateLabel(){
        let dateLabel = UILabel(frame: CGRect(x: 50, y: 10, width: self.view.frame.size.width/2 - 50, height: 30))
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        let imageV = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imageV.image = UIImage(named: "日历")
        self.headView .addSubview(imageV)
        
        //获取当前日期
        let currentDate = Date()
        //日期格式
        let dateFormat = DateFormatter()
        //自定义格式
        dateFormat.dateFormat = "YYYY-MM-dd"
        //转换字符串
        let string = dateFormat.string(from: currentDate)
        
        dateLabel.text = string
        dateLabel.textColor = UIColor(red: 0/255.0, green: 150/255.0, blue: 32/255.0, alpha: 1)
        
        self.headView .addSubview(dateLabel)
    }
    
    func setUpData(){
        //http://api.openweathermap.org/data/2.5/icon?q=changchun&lang=zh_cn&appid=03bf7e5f155c85e76937f31e583a56de
            //拼接参数
            let urlStr = "http://api.openweathermap.org/data/2.5/weather?q=changchun&lang=zh_cn&appid=03bf7e5f155c85e76937f31e583a56de"
            //url
            let url :URL! = URL(string: urlStr)
            
            guard NSData(contentsOf: url) != nil else{
                self.weatherLabel.text = "天气：暂无天气数据"
                
                return
            }
            //读取数据
            let weatherDate = NSData(contentsOf: url)
            

            //转化为JSON
            //将数据装入字典
            let json = (try! JSONSerialization.jsonObject(with: weatherDate! as Data, options: .mutableContainers)) as! [String : Any]


            //取出字典中数组
            let array : Array! = json["weather"] as? [Any]

            //取出数组中字典
            var dict = array[0] as! [String:Any]

            //按键取出对应值
            let weatherStr = dict["description"] as! String
            
            dict = (json["main"] as? [String:Any])!
            let tempNum = dict["temp"] as! NSNumber
            
            let tempStr : String = String(format: "%.2f", (CGFloat.init(exactly: tempNum)! - 273.15))
    //        tempLabel.text = "\(tempStr)°C"
    //        weatherLabel.text = weatherStr
//            self.headView.addSubview(self.weatherLabel)
            
            OperationQueue.main.addOperation {
                self.tempLabel.text = "\(tempStr)°C"
                self.weatherLabel.text = weatherStr
            }
    }
    
    //天气，温度
    func setUpWeatherLabel(){
        
        //天气
        let weatherLabel = UILabel(frame: CGRect(x: self.view.center.x + 50, y: 10, width: 80, height: 30))
        weatherLabel.font = UIFont.systemFont(ofSize: 14)
        weatherLabel.textColor = UIColor(red: 13/255.0, green: 91/255.0, blue: 193/255.0, alpha: 1)
        //天气图标
        let imageV = UIImageView(frame: CGRect(x: self.view.center.x + 10, y: 10, width: 30, height: 30))
        imageV.image = UIImage(named: "天气")
        
        //温度
        let tempLabel = UILabel(frame: CGRect(x: weatherLabel.frame.origin.x + weatherLabel.frame.size.width + 10, y: 10, width: 70, height: 30))
        tempLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(0.5))
        
        self.weatherLabel = weatherLabel
        self.tempLabel = tempLabel
        
        self.headView.addSubview(tempLabel)
        self.headView.addSubview(imageV)
        self.headView.addSubview(weatherLabel)
        
        
    }
    
    //name
    func setUpName(){
        let imageV = UIImageView(frame: CGRect(x: 10, y: 50, width: 30, height: 30))
        imageV.image = UIImage(named: "走路的人")
        
        let label = UILabel(frame: CGRect(x: 50, y: 50, width: self.view.frame.size.width/2 - 50, height: 30))
        label.text = "今日轨迹"
        label.font = UIFont.systemFont(ofSize: 14)
        
        self.headView.addSubview(label)
        self.headView.addSubview(imageV)
    }
    
    //定位
    func setUpLocation(){
        let imageV = UIImageView(frame: CGRect(x: 10, y: 120, width: 30, height: 30))
        imageV.image = UIImage(named: "定位")
        
        let label = UILabel(frame: CGRect(x: 50, y: 125, width: 50, height: 20))
        label.text = "坐标"
        label.font = UIFont.systemFont(ofSize: 14)
        
        self.headView.addSubview(label)
        self.headView.addSubview(imageV)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.array.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrajectoryCell(style: .subtitle, reuseIdentifier: "trajectory")
        cell.backgroundColor = UIColor(red: 253/255.0, green: 252/255.0, blue: 230/255.0, alpha: 1)
        
        if indexPath.row == self.array.count {
            cell.imageV.image = UIImage(named: "添加")
            cell.label.text = "添加..."
        }else{
            cell.item = self.array[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //点击添加
        if self.array.count == indexPath.row {
            
            let textF = UITextField()
            let alertVC = UIAlertController(title: nil, message: "请输入您要添加的地点", preferredStyle: UIAlertController.Style.alert)
            alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                if alertVC.textFields?.first?.text! != nil {
                    print(textF)
                    print(alertVC.textFields?.first?.text! as Any)
                                        
                    let dict : [String : Any] = Dictionary(dictionaryLiteral: ("iconName","小区"),("placeName",alertVC.textFields?.first?.text! ?? "123"),("imageCount",NSNumber.init(value: 0)),("imageData1",Data()),("imageData2",Data()),("imageData3",Data()))
                    
                    
                    
                    
                    //数据存储路径
//                    let path1 : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
//                    let fullPath : String = path1.appendingPathComponent("place.plist")
                    
                    //读取plist文件
//                    var path1 : String! = String()
//
//                    if FileManager.default.fileExists(atPath: self.fullPath) {
//                        path1 = self.fullPath
//                    }else{
//                        path1 = self.path
//                    }
                    
//                    let tempArray:NSMutableArray = NSMutableArray(contentsOfFile: path as String)!
                    self.tempArray.add(dict)
                    print("tempArray", self.tempArray)
                    
                    
//                    print("path:",self.fullPath)
                    self.tempArray.write(toFile: self.fullPath, atomically: true)
                    
                    self.freshData()
                    self.tableView.reloadData()
                }

                
            }))
            alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
            
            //添加文本输入
            alertVC.addTextField { textF in
                
                textF.placeholder = "请输入"
            }
            
            self.present(alertVC, animated: true, completion: nil)
        }else{//点击地点
            
            self.freshData()
            
            let editVC = EditLocationViewController()
            editVC.modalPresentationStyle = .fullScreen
            self.delegate = editVC
            
//            print(self.delegate as Any)
//            print((self.delegate?.responds(to: Selector.init(("locationDataItem:"))))!)
//            print(self.array[indexPath.row])
            
//            if self.delegate != nil && (self.delegate?.responds(to: Selector("locationDataItem:")))! {
            self.delegate?.locationDataItem(item: self.array[indexPath.row], index: indexPath.row)
//            }
            self.present(editVC, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteRowAction = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            
            //点击添加
            if self.array.count == indexPath.row {
                finished(false)
            }else{
                //删除数据
                self.array.remove(at: indexPath.row)
                //删除该行
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //重新存储数据
                self.tempArray.removeObject(at: indexPath.row)
                self.tempArray.write(toFile: self.fullPath, atomically: true)
                
                self.freshData()
                
                finished(true)
            }
            
            
        }
        
        deleteRowAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteRowAction])
    }
    
    //MARK: - UITextFiled
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("text",textField.text!)

    }
    
    //MARK: - LPLMainViewControllerDelegate
    func addLocation(location: String) {
        
        let dict : [String : Any] = Dictionary(dictionaryLiteral: ("iconName","小区"),("placeName",location),("imageCount",NSNumber.init(value: 0)),("imageData1",Data()),("imageData2",Data()),("imageData3",Data()))
        
        print(self.tempArray)
        
        self.tempArray.add(dict)
        
        print(self.tempArray)
        
        print(self.array)
        
        self.tempArray.write(toFile: self.fullPath, atomically: true)
        
//        self.freshData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.freshData()
        self.tableView.reloadData()
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
