//
//  TrajectoryCell.swift
//  轨迹生活
//
//  Created by home on 2020/2/14.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class TrajectoryCell: UITableViewCell {

    //图标
    var imageV : UIImageView!
    
    var _label : UILabel!
    //地点
    var label : UILabel!
        
    //模型
    var item : LocationItem?{
        didSet{
            self.imageV.image = UIImage(named: self.item!.iconName!)
            self.label.text = self.item?.placeName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageV = UIImageView()
        self.contentView.addSubview(imageV!)
        
        label = UILabel()
        self.contentView.addSubview(label!)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageV.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        label.frame = CGRect(x: 50, y: 15, width: 150, height: 20)
        label.font = UIFont.systemFont(ofSize: 14)
        
    }
}
