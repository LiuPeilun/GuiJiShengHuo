//
//  LPLMeTableViewCell.swift
//  轨迹生活
//
//  Created by home on 2020/2/6.
//  Copyright © 2020 lpl. All rights reserved.
//

import UIKit

class LPLMeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    //模型
    var item : MineItem!{
        didSet{
            label.text = self.item?.title
            imageV.image = UIImage(named: self.item!.iconName!)
            
//            print(self.item!.iconName!)
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
    
}
