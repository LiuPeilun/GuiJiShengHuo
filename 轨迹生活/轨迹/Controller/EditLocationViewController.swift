//
//  EditLocationViewController.swift
//  轨迹生活
//
//  Created by home on 2020/2/23.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol EditLocationDelegate : NSObjectProtocol{
    
    @objc func imageAndText(index : Int, arr : Array<LocationItem>)
}

class EditLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LPLTrajectoryDelegate,UITextViewDelegate {
    
    weak var delegate : EditLocationDelegate?
    
    //计时器
    lazy var timer : Timer = {
        return Timer()
    }()
    
    //计时器板
    var timeLabel : UILabel!
    
    //录音时长
    var audioTime : NSInteger = 0
    //录音素材路径
    var audioPathStr = String()
    //录音设置
    lazy var audioSetting : NSMutableDictionary = {
        let dict = NSMutableDictionary()
        //录音格式
        dict.setValue(NSNumber.init(value: kAudioFormatLinearPCM), forKey: AVFormatIDKey)//kAudioFormatLinearPCM
        //采样率
        dict.setValue(NSNumber.init(value: 11025.0), forKey: AVSampleRateKey)
        //通道数
        dict.setValue(NSNumber.init(value: 2), forKey: AVNumberOfChannelsKey)
        //音频质量
        dict.setValue(NSNumber.init(value: AVAudioQuality.min.rawValue), forKey: AVEncoderAudioQualityKey)
        
        return dict
    }()
    //录音器
    var audioRecorder : AVAudioRecorder!
    //存储录音名称+路径
    var audioDict : Dictionary = Dictionary<String,String>()
    
    //录音的数量
    var count : NSInteger = {
        return 1
    }()
    
    lazy var audioView : UIView = {
        
        let view : UIView = UIView()
        
        return view
    }()
    @IBOutlet weak var audioRecorderBtn: UIButton!
    
    //图库图片数组
    var imageArr : NSMutableArray = {
        let path1 : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        let fullPath : String = path1.appendingPathComponent("image.plist")
        let isExists = FileManager.default.fileExists(atPath: fullPath)
        
        var array : NSMutableArray
        if isExists == true {
            array = NSMutableArray(contentsOfFile: fullPath)!
        }else{
            array = NSMutableArray()
        }
        
        return array
    }()
    
    var text : String = String()
    
    @IBOutlet weak var saveBtn: UIButton!
    //地点图标
    @IBOutlet weak var icon: UIImageView!
    var iconName  = String()
    
    //文字编辑
    @IBOutlet weak var textView: UITextView!
    
    //地点名称
    @IBOutlet weak var location: UILabel!
    var placeName = String()
    //文字内容
    var string = String()
    //是否保存,默认已保存
    var isSaved = true
    
    //预览视图
    var coverView : UIView?
    
    //图片tag值
    var imageTag = Int()
    
    //图片
    var imageView1 : UIImageView?
    var imageView2 : UIImageView?
    var imageView3 : UIImageView?
    
    //图片数量
    var imageCount = 0
    
    //数组索引
    var index = 0
    
    //数据数组
    var dataArray : NSMutableArray = {
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
    
    //图片选择器懒加载
    lazy var pickVC : UIImagePickerController = {
       
        let pickVC = UIImagePickerController()
        pickVC.delegate = self
        
        pickVC.allowsEditing = true
        return pickVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //初始值
        self.icon.image = UIImage(named: self.iconName)
        self.location.text = self.placeName
        self.textView.text = self.string
        
        //有图片存储
        if self.imageCount != 0 {
            self.setImage()
        }
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        self.view.addGestureRecognizer(tap)
        
        //textView设置代理
        self.textView.delegate = self
        
//        //监听录音按钮的状态
//        self.audioRecorderBtn.addObserver(self, forKeyPath: "isSelected", options: NSKeyValueObservingOptions.new, context: .none)
        
        //按钮按下事件
        self.audioRecorderBtn.addTarget(self, action: #selector(audioRecorderBtnTouchDown(btn:)), for: .touchDown)
        //手指在按钮上离开触发
        self.audioRecorderBtn.addTarget(self, action: #selector(audioRecorderBtnTouchUp(btn:)), for: .touchUpInside)
    }
    
    @objc func audioRecorderBtnTouchDown(btn : UIButton){
        
        self.audioView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        //圆角
        self.audioView.layer.cornerRadius = 20
        self.audioView.layer.masksToBounds = true
        self.audioView.center = self.view.center
        self.audioView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        //提示文字
        let x : CGFloat = (self.audioView.frame.size.width-150)/2
        let y : CGFloat = self.audioView.frame.size.height/3
        let labelT = UILabel(frame: CGRect(x: x, y: y, width: 150, height: 20))
        labelT.textAlignment = NSTextAlignment.center
        labelT.text = "请您开始说话"
        labelT.textColor = UIColor.init(white: 1, alpha: 1)
        
        let labelB = UILabel(frame: CGRect(x: x, y: 2*y, width: 150, height: 20))
        labelB.text = "松手即停止录音"
        labelB.textColor = UIColor.init(white: 1, alpha: 1)
        labelB.textAlignment = NSTextAlignment.center
        
        self.timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.audioView.frame.size.width/5, height: self.audioView.frame.size.width/5))
        self.timeLabel.textAlignment = .center
        self.timeLabel.text = "\(self.audioTime)"
        self.timeLabel.textColor = UIColor.white
        
        self.audioView.addSubview(labelT)
        self.audioView.addSubview(labelB)
        self.view.addSubview(self.audioView)
        
        //初始化录音存储路径
        let path : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        let fullP : String = path.appendingPathComponent("audio\(self.count).caf")
        
        self.audioDict.updateValue("audio\(self.count)", forKey: fullP)
        
        let url = URL.init(string: fullP)
        do {
            let audioRecorder : AVAudioRecorder = try AVAudioRecorder(url: url!, settings: self.audioSetting as! [String : Any])
            self.audioRecorder = audioRecorder
        } catch  {}
        
        self.count += 1
        
        //创建音频会话对象
        let audioSession = AVAudioSession.sharedInstance()
        //设置category
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        } catch  {}
        
        
        if(self.audioRecorder != nil){
            //判断是否准备好
            if(self.audioRecorder.prepareToRecord() == true){
                //开始录音
                self.audioRecorder.record()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
                    self.audioTime += 1
                    self.timeLabel.text = "\(self.audioTime)"
                }
                
            }
        }
        
    }
    
    @objc func audioRecorderBtnTouchUp(btn : UIButton){
        
        self.audioRecorder.stop()
    
        self.audioView.removeFromSuperview()
        
        self.timer.invalidate()
        
        //如果录音时间小于三秒，不进行保存
        if(self.audioTime < 3){
            //删除录音
            self.audioRecorder.deleteRecording()
            self.count -= 1
        }
        
        self.audioTime = 0
        self.timeLabel.text = "0"
        
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if(keyPath == "isSelected"){
//            print("object",object as Any)
//            print("change",change as Any)
//        }
//    }
    
    @objc func viewTap(){
        //点击文本编辑界面外，收回键盘
        if self.textView.endEditing(false) == false{
            self.textView.endEditing(true)
        }
    }
    
    //读取数据创建imageView
    func setImage() {
        
        if self.imageCount == 1{
            let x : CGFloat = CGFloat((self.imageCount - 1) * 120 + 21)
            //添加按钮
            let btn : UIButton = UIButton(frame: CGRect(x: x, y: 300, width: 120, height: 120))
//            btn.backgroundColor = UIColor.gray
            btn.isUserInteractionEnabled = true
            btn.tag = 1
            
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            
            let dict : [String : Any] = self.dataArray[self.index] as! [String : Any]
            
            btn.setBackgroundImage(UIImage(data: dict["imageData1"] as! Data), for: .normal)
            self.textView.addSubview(btn)
        }else if self.imageCount == 2{
            for num in 1...2 {
                let x : CGFloat = CGFloat((num - 1) * 120 + 21)
                //添加按钮
                let btn : UIButton = UIButton(frame: CGRect(x: x, y: 300, width: 120, height: 120))
//                btn.backgroundColor = UIColor.gray
                btn.isUserInteractionEnabled = true
                btn.tag = num
                
                btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                
                let dict : [String : Any] = self.dataArray[self.index] as! [String : Any]
                btn.setBackgroundImage(UIImage(data: dict["imageData\(num)"] as! Data), for: .normal)
                self.textView.addSubview(btn)
            }
        }else if self.imageCount == 3{
            for num in 1...3 {
                let x : CGFloat = CGFloat((num - 1) * 120 + 21)
                //添加按钮
                let btn : UIButton = UIButton(frame: CGRect(x: x, y: 300, width: 120, height: 120))
//                btn.backgroundColor = UIColor.gray
                btn.isUserInteractionEnabled = true
                btn.tag = num
                
                btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                
                let dict : [String : Any] = self.dataArray[self.index] as! [String : Any]
                btn.setBackgroundImage(UIImage(data: dict["imageData\(num)"] as! Data), for: .normal)
                self.textView.addSubview(btn)
            }
        }
    }
    
    //图片预览
    @objc func btnClick(btn : UIButton){
        
        //图片预览
        let view : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        view.backgroundColor = UIColor.black
        
        self.view.addSubview(view)
        print("imagebtn",btn.imageView?.image as Any)
        
        let imageV : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 414, height: 414))
        imageV.contentMode = .scaleAspectFit
        imageV.image = btn.backgroundImage(for: .normal)
        imageV.center = self.view.center
        view.addSubview(imageV)
        
        self.coverView = view
        
        self.imageTag = btn.tag
        
        self.setUpBtns(view: self.coverView!)
    }
    
    //创建预览界面返回，删除按钮
    func setUpBtns( view : UIView){
        let backBtn : UIButton = UIButton(frame: CGRect(x: 10, y: 20, width: 25, height: 25))
        backBtn.addTarget(self, action: #selector(backBtnClick(btn:)), for: .touchUpInside)
        let deletBtn : UIButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 25 - 10, y: 20, width: 25, height: 25))
        deletBtn.addTarget(self, action: #selector(deletBtnClick(btn:)), for: .touchUpInside)
        
        backBtn.setImage(UIImage(named: "返回1"), for: .normal)
        deletBtn.setImage(UIImage(named: "垃圾桶"), for: .normal)
        
        view.addSubview(backBtn)
        view.addSubview(deletBtn)
        
    }
    
    //预览界面返回按钮点击
    @objc func backBtnClick(btn:UIButton){
        
        btn.superview?.removeFromSuperview()
    }
    
    //预览界面删除按钮点击
    @objc func deletBtnClick(btn:UIButton){
        let alertVC : UIAlertController = UIAlertController(title: "确定要删除该图片吗", message: nil, preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (UIAlertAction) in
            
            //存储路径
            let path1 : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
            let fullPath : String = path1.appendingPathComponent("place.plist")
            
            var dict : [String : Any] = self.dataArray[self.index] as! [String : Any]
            
            print("imageCount : ",self.imageCount)
            
            //如果点击的图片不是最后一个
            if self.imageTag < self.imageCount{
                //从前到后遍历图片索引
                for num in self.imageTag...self.imageCount{
                    
                    if num == self.imageCount{
                        if self.imageCount > 0{
                            //图片数量减一
                            self.imageCount -= 1
                        }
                        
                    }else{//一次将点击图片后面图片的数据向前移一位
                        dict["imageCount\(num)"] = dict["imageCount\(num + 1)"]
                    }
                }
                
            }else{//点击的图片是最后一个
                
                if self.imageCount > 0{
                    //图片数量减一
                    self.imageCount -= 1
                }
                
                dict["imageData\(self.imageTag)"] = nil
                dict["imageCount"] = self.imageCount
                
            }
            
            self.dataArray.replaceObject(at: self.index, with: dict)
            //存储文件
            self.dataArray.write(toFile: fullPath, atomically: true)
            
            //移除图片预览界面
            self.coverView?.removeFromSuperview()
            //刷新界面
            self.reloadImage()
            
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //刷新图片视图
    func reloadImage(){
        
        for imageV in self.textView.subviews{
            //移除
            if imageV.isKind(of: UIButton.classForCoder()){
                print(imageV.tag)
                imageV.removeFromSuperview()
            }
        }
        //重新加载图片
        self.setImage()
    }
    
    @objc func imageAndTitle(notification : Notification){
        let item : LocationItem = notification.userInfo!["item"] as! LocationItem
        self.icon.image = UIImage(named: item.iconName!)
        self.location.text = item.placeName
    }
    
    //返回
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        if self.isSaved == false{
            let alertVC : UIAlertController = UIAlertController(title: "还没有保存，确定要退出吗？", message: nil, preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (UIAlertAction) in
                //退出界面
                self.dismiss(animated: true, completion: nil)
            }))
            
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            
            self.present(alertVC, animated: true, completion: nil)
        }else{
            //没有编辑的情况可以正常退出
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    //保存
    @IBAction func save(_ sender: UIButton) {
        
        sender.isUserInteractionEnabled = false
        self.isSaved = true
        
        let path1 : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        let fullPath : String = path1.appendingPathComponent("place.plist")
        
        
        
        var dict : [String : Any] = self.dataArray[self.index] as! [String : Any]
        dict["string"] = self.textView.text
        print("self.textView.text",self.textView.text!)
        self.dataArray.replaceObject(at: self.index, with: dict)
        self.dataArray.write(toFile: fullPath, atomically: true)
        
        //开启一个图形上下文
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0)
        //拿到图片上下文
        let ctx : CGContext = UIGraphicsGetCurrentContext()!
        
        //将目标视图渲染到上下文上
        self.view.layer.render(in: ctx)
        //将图片取出来c
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        print(image as Any)
        let imageData = image?.pngData()
        //将图片存储到数组
        self.imageArr.add(imageData as Any)
        //路径
        let path : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        let fullP : String = path.appendingPathComponent("image.plist")
        
        print(fullP)
        //将数组存储文件
        self.imageArr.write(toFile: fullP, atomically: true)
        
        let stockVC = LPLStockTableViewController()
        self.delegate = stockVC 
        
//        if self.delegate!.responds(to: Selector(("imageWithText:"))){
        self.delegate?.imageAndText(index: self.index, arr: self.dataArray as! Array<LocationItem>)
//        }
        
    }
    
    //添加图片按钮点击
    @IBAction func addImage(_ sender: UIButton) {
        
        if self.imageCount == 3{
            return
        }
        
        let alertVC : UIAlertController = UIAlertController(title: "添加图片", message: "您要通过哪种方式添加？", preferredStyle: UIAlertController.Style.actionSheet)
        
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
    }
    
    //向文本中添加图片
    func addImageToTextView(image : UIImage){
        
        //创建附件
        let attachment = NSTextAttachment()
        attachment.image = image
        
        //设置附件大小
        attachment.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        //将附件转化为富文本(NSAttributedString)
        let attStr = NSAttributedString(attachment: attachment)
        
        //获取文本框上已有的文字,转化成可变文本
        let mutableString = NSMutableAttributedString(attributedString: textView.attributedText)
        //获取目前文本框光标的位置
        let selectRange = textView.selectedRange
        
        //在光标位置后插入图片
        mutableString.insert(attStr, at: selectRange.location)
        
        //重新为文本框赋文本
        textView.attributedText = mutableString
        
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
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //判断选中类型
        let typeStr : String = info[UIImagePickerController.InfoKey.mediaType] as! String
        //如果是图片
        if typeStr == "public.image"{
            //判断图片有没有值
            if let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                
                let path1 : NSString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
                let fullPath : String = path1.appendingPathComponent("place.plist")
                
                print(fullPath)
                
                self.imageCount += 1
//                self.addImageToTextView(image: image)
                let x : CGFloat = CGFloat((self.imageCount - 1) * 120 + 21)
                //添加按钮
                let btn : UIButton = UIButton(frame: CGRect(x: x, y: 300, width: 120, height: 120))
                btn.tag = self.imageCount
//                btn.backgroundColor = UIColor.gray
                btn.isUserInteractionEnabled = true
                
                btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                btn.setBackgroundImage(image, for: .normal)
                self.textView.addSubview(btn)
                
                //添加数据
                let imageData = image.pngData()
                var dict : [String : Any] = self.dataArray[self.index] as! [String : Any]
//                print("dict",dict)
//                print("imageData:",imageData as Any)
//                print("imageData\(self.imageCount)")
                
                dict.updateValue(NSNumber.init(integerLiteral: self.imageCount), forKey: "imageCount")
                dict["imageData\(self.imageCount)"] = imageData
                
//                print("dict",dict)
                
                
                self.dataArray.replaceObject(at: self.index, with: dict)
                self.dataArray.write(toFile: fullPath, atomically: true)
                
                self.isSaved = false
                self.saveBtn.isUserInteractionEnabled = true
                
                print("imageCount",self.imageCount)
                
            }else{//图片获取失败
                let alertVC = UIAlertController(title: "添加图片失败", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: nil))
            }
        }else{
            print("选择图片失败！")
        }
        
        pickVC.dismiss(animated: true, completion: nil)
        
    }
    
    //图片选择器回调方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickVC.dismiss(animated: true, completion: nil)
    }
    
    
    //自定代理方法
    func locationDataItem(item: LocationItem, index: Int) {
        
        print(item.placeName as Any)
        print(self.placeName)
        
        self.placeName = item.placeName!
        self.iconName = item.iconName!
        self.imageCount = item.imageCount!
        self.index = index
        self.string = item.string ?? ""
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        self.isSaved = false
        self.saveBtn.isUserInteractionEnabled = true
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
