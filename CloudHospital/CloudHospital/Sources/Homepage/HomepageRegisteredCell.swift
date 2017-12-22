//
//  HomepageRegisteredCell.swift
//  CloudHospital
//
//  Created by wangankui on 22/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import UIKit

class HomepageRegisteredCell: UITableViewCell {
    
    @IBOutlet weak var leftmageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var topLeftLabel: UILabel!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var topRightLeftLabel: UILabel!
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configurrData() {
        let leftURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/0cfc4ed02d6c46b28162803d3084c567.png")!
        let leftData = try? Data(contentsOf: leftURL)
        self.leftmageView.image = UIImage(data: leftData!)
        
        let topLeftURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/730219e7bfd642af867329745b02e602.png")!
        let topLeftData = try? Data(contentsOf: topLeftURL)
        self.topLeftImageView.image = UIImage(data: topLeftData!)
        
        let topRightURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/99b9da248ba04c4882745f0868937700.png")!
        let topRightData = try? Data(contentsOf: topRightURL)
        self.topRightImageView.image = UIImage(data: topRightData!)
        
        let bottomURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/1b8fbe1eb2f64add90f12182d6884f16.png")!
        let bottomData = try? Data(contentsOf: bottomURL)
        self.bottomImageView.image = UIImage(data: bottomData!)
    }
}
