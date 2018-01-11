//
//  Resource.swift
//  CloudHospital
//
//  Created by wangankui on 11/01/2018.
//  Copyright © 2018 oneday. All rights reserved.
//

import Foundation

struct Episode {
    let id: String
    let title: String
}

extension Episode {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String else { return nil }
        
        self.id = id
        self.title = title
    }
}

extension Episode {
    static let all = Resource<[Episode]>(url: url, parseJSON: { json in
        guard let dictionaries = json as? [String: Any] else { return nil }
        
        return nil //dictionaries.flatMap(Episode.init)
    })
}




let url = URL(string: "http://localhost:8000/episodes.json")!

struct Resource<A> {
    let url: URL
    let parse: (Any) -> A?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.parse = { data in
            
            let json = try? JSONSerialization.jsonObject(with: data as! Data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

final class Webservice {
    func start<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            completion(resource.parse(data))
            
        }.resume()
    }
}
