//
//  HomepageConsultationCell.swift
//  CloudHospital
//
//  Created by wangankui on 22/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import UIKit

class HomepageConsultationCell: UITableViewCell {
    
    @IBOutlet weak var leftmageView: UIImageView!
    @IBOutlet weak var lefttitleLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configurrData() {
        let leftURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/7f497af0571945b1a3451ef656526b3a.png")!
        let leftData = try? Data(contentsOf: leftURL)
        self.leftmageView.image = UIImage(data: leftData!)
        
        let topURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/3d6681cfc6ee4d68b848608186abdb6e.png")!
        let topData = try? Data(contentsOf: topURL)
        self.topImageView.image = UIImage(data: topData!)

        let bottomURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/be6398b300ee4c33a46f84ec8971480f.png")!
        let bottomData = try? Data(contentsOf: bottomURL)
        self.bottomImageView.image = UIImage(data: bottomData!)
    }
}
