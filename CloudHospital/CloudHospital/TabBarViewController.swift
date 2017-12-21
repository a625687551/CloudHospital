//
//  TabBarViewController.swift
//  CloudHospital
//
//  Created by wangankui on 21/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.setupItemAttrs()
        self.addAllChildViewControllers()
    }
    
    func setupItemAttrs() {
        let normal = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        let selected = [NSAttributedStringKey.foregroundColor: UIColor.green]
        
        let item = UITabBarItem.appearance()
        item.setTitleTextAttributes(normal, for: .normal)
        item.setTitleTextAttributes(selected, for: .selected)
    }
    
    func addAllChildViewControllers() {
        self.addViewController(child: HomepageViewController(), title: "云医院", normal: "bottom_nav_home", selected: "bottom_nav_home_sel")
        self.addViewController(child: MessageViewController(), title: "消息", normal: "bottom_nav_new", selected: "bottom_nav_new_sel")
        self.addViewController(child: ServiceViewController(), title: "服务窗", normal: "bottom_nav_fwc", selected: "bottom_nav_fwc_sel")
        self.addViewController(child: HealthViewController(), title: "健康档案", normal: "bottom_nav_jkda", selected: "bottom_nav_jkda_sel")
        self.addViewController(child: MeViewController(), title: "我", normal: "bottom_nav_my", selected: "bottom_nav_my_sel")
    }
    
    func addViewController(child: UIViewController, title: String, normal: String, selected: String) {
        child.tabBarItem = UITabBarItem(title: title, image: UIImage(named: normal), selectedImage: UIImage(named: selected))
        self.addChildViewController(child)
    }
}
