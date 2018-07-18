//
//  MovieDetail.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 13/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit

class MovieDetail: Codable {
    
    var id: Int?
    var title: String?
    var poster_path: String?
    var backdrop_path: String?
    var overview: String?
    var release_date: String?
    var popularity: Double?
    var vote_average: Double?
    
    init(id: Int, title: String, poster_path: String, backdrop_path: String, overview: String, release_date: String, popularity: Double, vote_average: Double ) {
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        self.overview = overview
        self.release_date = release_date
        
        self.popularity = popularity
        self.vote_average = vote_average
    }
    
    convenience init() {
        self.init(id: -1, title: "", poster_path: "", backdrop_path: "", overview: "", release_date: "", popularity: 0.0, vote_average: 0.0)
        
    }
    
    func getPosterURL() -> URL?{
        if let poster = poster_path {
            return URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
        } else {
            return nil
        }
        
    }
    
    func getBackDropURL() -> URL?{
        if let backdrop = backdrop_path {
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop)")
        }
        return nil
    }
    
}



class MovieResponseDetail: Codable {
    
    let results: [MovieDetail]
    init(results:[MovieDetail]) {
        self.results = results
    }
}
