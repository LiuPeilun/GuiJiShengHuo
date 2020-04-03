//
//  LPLMainViewController.swift
//  轨迹生活
//
//  Created by home on 2020/2/6.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//协议
protocol LPLMainViewControllerDelegate : NSObjectProtocol{
    func addLocation(location : String)
}

class LPLMainViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    

    //地图
    var mapView : MKMapView!
    //轮播页码
    var pageControl : UIPageControl!
    //轮播界面
    var imageScrollView : UIScrollView!
    //定位管理者
    var manager : CLLocationManager!
    //计时器
    var timer : Timer?
    //搜索框
    var searchView : UIView!
    //textFiled
    var textFiled : UITextField!
    //搜索框状态
    var isShow : Bool = false
    //搜索框编辑状态
//    var isEdit : Bool = false
    //代理
    weak var delegate : LPLMainViewControllerDelegate?
    
    //大头针
    let currentAnnotation : MKAnnotation! = nil
    //地理编码
    lazy var geocoder : CLGeocoder = {
        let geocoder : CLGeocoder = CLGeocoder()
        
        return geocoder
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        
        self.setUpImageScrollView()
        
        self.setUpMapView()
        
        self.setUpSearchView()
        self.setUpShowSearchBtn()
        
        self.startTimer()
        
        self.delegate = LPLTrajectoryTableViewController.trvVC
        
    }
    
//    //点击地图
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //拿到点击
//        let touch = touches.first
//        //获取当前点击点在地图上的坐标
//        let point : CGPoint = (touch?.location(in: self.mapView))!
//        //将坐标转化为经纬度
//        let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
//
//        //创建大头针
//        let annotation = CustomAnnotation()
//
//        //根据经纬度添加大头针
//        self.addAnnotationWithCooedinate(coordinate: coordinate)
//    }
    
    //根据经纬度添加大头针
    func addAnnotationWithCooedinate(coordinate : CLLocationCoordinate2D){
        
        
    }
    
    //创建显示搜索框按钮
    func setUpShowSearchBtn (){
        let viewWH : CGFloat = 50
        let view : UIView = UIView(frame: CGRect(x: self.view.frame.size.width - viewWH, y: 310, width: viewWH, height: viewWH))
        //黑色
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.layer.cornerRadius = viewWH/2
        view.layer.masksToBounds = true
        self.view.addSubview(view)
        
        let btnWH : CGFloat = 25;
        let button : UIButton = UIButton(frame: CGRect(x: (viewWH-btnWH)/2, y: (viewWH-btnWH)/2, width: btnWH, height: btnWH))
        button.setImage(UIImage(named: "搜索"), for: .normal)
        
        button.addTarget(self, action: #selector(showBtnClick(btn:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    //点击显示搜索按钮
    @objc func showBtnClick(btn : UIButton){
        
        if self.isShow == false{
            UIView.animate(withDuration: 0.5) {
                self.searchView.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: 0)
            }
            self.isShow = true
        }else{
            UIView.animate(withDuration: 0.5) {
            self.searchView.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 0)
            }
            self.isShow = false
            self.textFiled.endEditing(true)
            self.textFiled.text = ""
        }
        
        
        
    }
    
    //创建搜索框
    func setUpSearchView(){
        
        let searchViewW : CGFloat = self.view.frame.size.width * 2/3
        
        //搜索框
        let searchView = UIView(frame: CGRect(x: self.view.frame.size.width*7/6 , y: self.imageScrollView.frame.origin.y + self.imageScrollView.frame.size.height + 5, width: searchViewW, height: 35))
        searchView.backgroundColor = UIColor.white
        
        self.searchView = searchView
        self.view.addSubview(searchView)
        
        //textFiled
        let textFiled = UITextField(frame: CGRect(x: 10, y: 3, width: self.searchView.frame.size.width-80, height: 30))
        self.textFiled = textFiled
        textFiled.placeholder = "请输入目的地"
        self.searchView.addSubview(textFiled)
        
        //UIButton
        let searchBtn = UIButton(frame: CGRect(x: self.textFiled.frame.origin.x + self.textFiled.frame.size.width + 10, y: 5, width: 50, height: 25))
        searchBtn.backgroundColor = UIColor.black
        searchBtn.setTitle("搜索", for: .normal)
        
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        self.searchView.addSubview(searchBtn)
    }
    
    //搜索按钮点击
    @objc func searchBtnClick(){
        //获取用户输入的地址
        if self.textFiled.text == "" {
            return
        }
        let address = self.textFiled.text
        self.textFiled.endEditing(true)
        print(self.textFiled.text as Any)
        
        //地理编码
        //CLPlacemark:包含了该位置的经纬度，城市，区域，国家代码，邮编等
        self.geocoder.geocodeAddressString(address!) { (placemarks:[CLPlacemark]?, error:Error?) in
            
            if(placemarks?.count == 0){
                return
            }
            //placemarks地标数组
            //拿到数组中的第一个地标
            let placemark : CLPlacemark = (placemarks?.first)!
            
            //判断是否实现并调用代理方法
            self.delegate?.addLocation(location: placemark.name!)
            
            //创建终点item
            let destination = MKPlacemark(placemark: placemark)
            let destinationItem = MKMapItem(placemark: destination)
            //获取起点的item
            let originItem = MKMapItem.forCurrentLocation()
            //调用导航方法
            self.starNavigationWithItem(originItem: originItem, destinationItem: destinationItem)
            
            
        }
    }
    
    func starNavigationWithItem(originItem : MKMapItem,destinationItem : MKMapItem){
        //创建路线请求对象
        let request = MKDirections.Request()
        //给request设置起点和终点位置
        //起点
        request.source = originItem
        //终点
        request.destination = destinationItem
        
        //创建路线对象
        let directions = MKDirections(request: request)
        //请求路线
        directions.calculate { (response:MKDirections.Response?, error:Error?) in
            //错误校验
            if error != nil{
                print(error as Any)
                return
            }
            //校验是否有响应
            guard response != nil else{
                return
            }
            //获取所有的路线
            for route in response!.routes{
                for step in route.steps{
                    self.mapView.addOverlay(step.polyline)
                }
            }
        }
    }
    
    //开启计时器
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (Timer) in
            
            UIView.animate(withDuration: 0.3) {
                //滚动到最后一张图
                if self.imageScrollView.contentOffset.x == self.view.frame.size.width * 2{
                    //回到第一张
                    self.imageScrollView.contentOffset.x = 0
                    self.pageControl.currentPage = 0
                }else{//不是最后一张图
                    //滚到下一张
                    self.imageScrollView.contentOffset.x += self.view.frame.size.width
                    self.pageControl.currentPage = Int(self.imageScrollView.contentOffset.x/self.view.frame.size.width)
                }
            }
        })
    }
    
    //停止计时
    func stopTimer() {
        if timer != nil{
            //销毁
            timer!.invalidate()
            //置空
            timer = nil
        }
    }
    
    func setUpImageScrollView() {
        //创建轮播图
        imageScrollView = ImageScrollView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 200))
        
        //设置内容大小
        imageScrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: 0)
        self.view.addSubview(imageScrollView)
        
        //设置分页
        imageScrollView.isPagingEnabled = true
        //消除滚动条
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        //添加监听
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapScrollView))
        imageScrollView.addGestureRecognizer(tap)
        
        //创建页码
        pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        
        self.view.addSubview(pageControl)
        pageControl.frame = CGRect(x: self.view.center.x - 50, y: 234, width: 100, height: 30)
        
    }
    
    //点击轮播图
    @objc func tapScrollView() {
        //进入界面一
        if self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width == 0{
            
            //进入界面二
        }else if self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width == 1{
            let two : PageTwoViewController = PageTwoViewController()
            two.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(two, animated: true, completion: nil)
            //进入界面三
        }else if self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width == 2{
            let three : PageThreeViewController = PageThreeViewController()
            three.modalPresentationStyle = .fullScreen
            self.present(three, animated: true, completion: nil)
        }else{
            return
        }
    }
    
    func setUpMapView(){
        
        let mapView = MKMapView()
        self.mapView = mapView
        //地图类型
        mapView.mapType = .standard
        //定位管理者
        let manager = CLLocationManager()
        //询问权限
        //首先请求总是访问权限
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        //是否允许系统自动暂停位置更新服务，默认为true，系统会在app处于后台20分钟左右，自动暂停位置服务
        
        //设置监听(监听定位，手机头，区域)
        manager.startUpdatingHeading()
        manager.startUpdatingLocation()
        
        self.manager = manager
        
        //显示用户位置
        mapView.showsUserLocation = true
        //扇形指向方向
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        //显示交通状况
        mapView.showsTraffic = true
        //指南针
        mapView.showsCompass = true
        //显示标志建筑
        mapView.showsBuildings = true
        //是否可以缩放
        mapView.isZoomEnabled = true
        //是否显示3D
        mapView.isPitchEnabled = true
        //是否可以旋转
        mapView.isRotateEnabled = true
        //是否可以滚动
        mapView.isScrollEnabled = true
        
        //设置代理
        mapView.delegate = self
        
        self.view.addSubview(mapView)
        mapView.frame = CGRect(x: 0, y: 264, width: self.view.frame.size.width, height: 736 - 264 - 49)
        
        //添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPress:)))
        mapView.addGestureRecognizer(longPress)
        
        
    }
    
    @objc func longPress(longPress : UILongPressGestureRecognizer) {
        if longPress.state != UILongPressGestureRecognizer.State.began {
            return
        }
        
        //1.拿到长按的点的坐标
        let point = longPress.location(in: self.mapView)
        
        //2.根据点的位置转化为坐标
        let coord = self.mapView.convert(point, toCoordinateFrom: self.mapView)
        
        //3.创建大头针
        let annotation : MKPointAnnotation = MKPointAnnotation()
        
        //4.根据坐标的经纬度创建定位
        let location = CLLocation.init(latitude: coord.latitude, longitude: coord.longitude)
        
        //5.反地理编码
        self.geocoder.reverseGeocodeLocation(location) { (placemarks : [CLPlacemark]?, error : Error?) in
            //拿到地标
            let placemark = placemarks?.first
            //根据地标拿到地名
            annotation.title = placemark?.name
            
            //地图添加大头针
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    //MARK: - UIScrollViewDelegate
    //手指开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //停止计时
        self.stopTimer()
    }
    
    //手指结束拖拽，离开屏幕
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //重新开始计时
        self.startTimer()
    }
    
    //轮播图停止滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let count : Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        print("count = ",count)
        
        pageControl.currentPage = count
    }
    
    //MARK: - MKMapViewDelegate
    //MKUserLocation是个大头针模型，包括title subtitle location三个属性
    //一个位置更改只会调用一次，不断检测用户的当前位置
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //大头针标注要显示的标题
        userLocation.title = "我的位置"
        //大头针显示的子标题
//        userLocation.subtitle = "haha"
        
//        print(userLocation.coordinate)
//        print(self.mapView as Any)
        
        //设置用户大头针在地图中心
        self.mapView.setCenter(userLocation.coordinate, animated: true)
        
        //设置经纬度，越小地图越详细
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        //设置经纬度区域
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        //设置地图显示区域
        self.mapView.setRegion(region, animated: true)
    }
    
    //自定义导航路线遮盖
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //创建遮盖
        let coverLine = MKPolylineRenderer(overlay: overlay)
        //遮盖线宽
        coverLine.lineWidth = 5
        //颜色
        coverLine.strokeColor = UIColor.red
        
        return coverLine
    }
    
    //设置大头针(MKAnnotation)
    //每添加一个大头针，就调用
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //去复用池找大头针，跟cell一个原理
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "an")
        //没有就创建一个新的
        if annotationView == nil{
            annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "an")
        }

        annotationView?.image = UIImage(named: "定位")

        //可以展示气泡
        annotationView?.canShowCallout = true

        return annotationView
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        
//    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        self.mapView.removeFromSuperview()
//        self.manager = nil
//        self.mapView = nil
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
