//
//  Trailer.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 17/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import Foundation

struct Trailer: Codable {
    
    var id: String?
    var key: String?
    var name: String?
    var site: String?
    
    init(id: String, key:String, name:String, site:String) {
        self.id = id
        self.key = key
        self.name = name
        self.site = site
    }
}

struct TrailerResponse: Codable {
    var id: Int?
    var results: [Trailer]?
    
    init(id: Int, results:[Trailer]) {
        self.id = id
        self.results = results
    }
}
