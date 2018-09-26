//
//  Movie.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 11/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import Foundation

class Movie: Codable {
    
    var id: Int?
    var title: String?
    var video: Bool?
    var poster_path: String?
    var backdrop_path: String?
    var overview: String?
    var release_date: String?
    
    
    init(id: Int, title: String, video: Bool, poster_path: String, backdrop_path: String, overview: String, release_date: String ) {
        self.id = id
        self.title = title
        self.video = video
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        self.overview = overview
        self.release_date = release_date
    }
    
    convenience init(){
        self.init(id: -1, title: "", video: false, poster_path: "", backdrop_path: "", overview: "", release_date: "")
    }
    
    func getMovieURL() -> URL?{
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path!)")
    }
    
}

class MovieResponse: Codable {

    let results: [Movie]
    init(results:[Movie]) {
        self.results = results
    }
}


