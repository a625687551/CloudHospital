//
//  HomepageViewController.swift
//  CloudHospital
//
//  Created by wangankui on 21/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import UIKit
import Alamofire

class HomepageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.background
    
        let parameters: [String : Any]? = nil 
        DataManager.shared.start(parameters: parameters) { response, error in
            
        }

        
    }
}

extension HomepageViewController {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let identifier = "cycleScroll"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomepageCycleScrollCell
        case 1:
            let identifier = "consultation"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomepageConsultationCell
            cell.configurrData()
        case 2:
            let identifier = "registered"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomepageRegisteredCell
            cell.configurrData()
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 115
        case 1:
            return 210
        case 2:
            return 200
        default:
            break
        }
        return 0
    }
}

