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
    let topButtons: [AppMenu]
    struct AppMenu: Codable {
        let img: String
        let title: String
        let subTitle: String
        let linkType: Int
        let scheme: String
        let groupby: Int
        let minImg: String
        let minImgStime: String
        let minImgEtime: String
        let serverTime: String
        let enableFlag: String
    }
    let middleButtons: [AppMenu]
    let bottomButtons: [AppMenu]
    let consButtons: [AppMenu]
    
    let banners: [AppBanner]
    struct AppBanner: Codable {
        let title: String
        let cover: String
        let linkType: Int
        let link: String
        let scheme: Int
        let updateTime: String
    }
    
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
    
    let recommendDocs: [Doctor]
    struct Doctor: Codable {
        let docId: Int
        let name: String
        let headPhoto: String
        let sectId: Int
        let sectName: String
    }
}
