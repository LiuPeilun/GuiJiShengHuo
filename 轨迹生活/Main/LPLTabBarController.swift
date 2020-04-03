//
//  LPLTabBarController.swift
//  轨迹生活
//
//  Created by home on 2020/2/6.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class LPLTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //创建所有子控制器
        self.setUpAllChildController()
        
        //设置tabbar按钮
        self.setUpTabBarButton()
        // Do any additional setup after loading the view.
        self.selectedIndex = 2
    }
    
    //创建所有子控制器
    func setUpAllChildController() {
        //1.轨迹
        let traVC = LPLTrajectoryTableViewController()
        let navVC1 = UINavigationController(rootViewController: traVC)
        navVC1.navigationBar.topItem?.title = "轨迹"
        self.addChild(navVC1)
        
        //2.存库
        let stockVC = LPLStockTableViewController()
        let navVC2 = UINavigationController(rootViewController: stockVC)
        navVC2.navigationBar.topItem?.title = "存库"
        self.addChild(navVC2)
        
        //3.主页
        let mainVC = LPLMainViewController()
        let navVC3 = UINavigationController(rootViewController: mainVC)
        navVC3.navigationBar.topItem?.title = "主页"
        self.addChild(navVC3)
        
        //4.轨迹圈
        let traLoopVC = LPLTrajectoryLoopTableViewController()
        let navVC4 = UINavigationController(rootViewController: traLoopVC)
        navVC4.navigationBar.topItem?.title = "轨迹圈"
        self.addChild(navVC4)
        
        //5.我的
        let meVC = LPLMeTableViewController()
        let navVC5 = UINavigationController(rootViewController: meVC)
        navVC5.navigationBar.topItem?.title = "我的"
        self.addChild(navVC5)
    }

    //设置tabBar按钮
    func setUpTabBarButton() {
        let navVC = self.children[0]
        navVC.tabBarItem.title = "轨迹"
        navVC.tabBarItem.image = UIImage(named: "轨迹灰色")?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem.selectedImage = UIImage(named: "轨迹")?.withRenderingMode(.alwaysOriginal)
        
        let navVC1 = self.children[1]
        navVC1.tabBarItem.title = "库存"
        navVC1.tabBarItem.image = UIImage(named: "库存灰色")?.withRenderingMode(.alwaysOriginal)
        navVC1.tabBarItem.selectedImage = UIImage(named: "库存")?.withRenderingMode(.alwaysOriginal)
        
        let navVC2 = self.children[2]
//        navVC2.tabBarItem.title = "主页"
        navVC2.tabBarItem.image = UIImage(named: "主页灰色")?.withRenderingMode(.alwaysOriginal)
        navVC2.tabBarItem.selectedImage = UIImage(named: "主页")?.withRenderingMode(.alwaysOriginal)
        
        let navVC3 = self.children[3]
        navVC3.tabBarItem.title = "轨迹圈"
        navVC3.tabBarItem.image = UIImage(named: "轨迹圈灰色")?.withRenderingMode(.alwaysOriginal)
        navVC3.tabBarItem.selectedImage = UIImage(named: "轨迹圈")?.withRenderingMode(.alwaysOriginal)
        
        let navVC4 = self.children[4]
        navVC4.tabBarItem.title = "我的"
        navVC4.tabBarItem.image = UIImage(named: "我的灰色")?.withRenderingMode(.alwaysOriginal)
        navVC4.tabBarItem.selectedImage = UIImage(named: "我的")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tabBar.frame = CGRect(x: 0, y: self.tabBar.frame.origin.y - 20, width: self.view.frame.size.width, height: 69)
        
        self.tabBar.backgroundColor = UIColor.white
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
