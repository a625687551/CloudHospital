//
//  HomepageConsultationCell.swift
//  CloudHospital
//
//  Created by wangankui on 22/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import UIKit
import Kingfisher

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
        self.leftmageView.kf.setImage(with: leftURL)
        
        let topURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/3d6681cfc6ee4d68b848608186abdb6e.png")!
        self.topImageView.kf.setImage(with: topURL)

        let bottomURL = URL(string: "https://hshospital.oss-cn-hangzhou.aliyuncs.com/be6398b300ee4c33a46f84ec8971480f.png")!
        self.bottomImageView.kf.setImage(with: bottomURL)
    }
}
