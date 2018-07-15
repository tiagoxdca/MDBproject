//
//  MovieTrailer.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 13/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit

class MovieTrailer: Codable {
    
    var id: String
    var key: String
    var name: String
    var site: String
    var size: Int
    var type: String
    
    init(id: String, key: String, name: String, site: String, size: Int, type: String) {
        self.id = id
        self.key = key
        self.name = name
        self.site = site
        self.size = size
        self.type = type
    }
    
    convenience init() {
        self.init(id: "", key: "", name: "", site: "", size: 0, type: "")
    }
    

    
}

class MovieResponseTrailer: Codable {
    
    let results: [MovieTrailer]
    init(results:[MovieTrailer]) {
        self.results = results
    }
}
