//
//  PageThreeViewController.swift
//  轨迹生活
//
//  Created by home on 2020/3/1.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class PageThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.setUpScrollView()
        // Do any additional setup after loading the view.
    }
    
    func setUpScrollView(){
        let scrollView : UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        scrollView.contentSize = CGSize(width: 414, height: 1029)
        self.view.addSubview(scrollView)
        
        let imageV : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: 1029))
        imageV.image = UIImage(named: "轮播3回家页面")
        scrollView.addSubview(imageV)
        
        let backBtn : UIButton = UIButton(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        backBtn.setImage(UIImage(named: "返回1"), for: .normal)
        scrollView.addSubview(backBtn)
        
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        
    }
    
    @objc func backBtnClick(){
        self.dismiss(animated: true, completion: nil)
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
