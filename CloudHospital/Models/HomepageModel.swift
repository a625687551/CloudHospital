//
//  HomepageModel.swift
//  CloudHospital
//
//  Created by wangankui on 28/12/2017.
//  Copyright © 2017 oneday. All rights reserved.
//

import Foundation

struct HomepageModel: Codable {
    let templateCode: String
    let topButtons: [Any]
    let middleButtons: [Any]
    let bottomButtons: [Any]
    let consButtons: [Any]
    let banners: [Any]
    let healthArticles: HealthArticle
    
    struct HealthArticle: Codable {
        let pageSize: Int
        let pageNum: Int
        let total: Int
        let pages: Int
        let hasPreviousPage: Int
        let hasNextPage: Int
        let list: [Article]
    }
    
    struct Article: Codable {
        let archiveId: Int
        let archiveName: String
        let cover: String
        let title: String
        let updateTime: String
        let summary: String
        let link: String
    }
    
    let recommendDocs: [Any]
}

