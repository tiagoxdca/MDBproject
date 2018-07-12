//
//  MovieREST.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 12/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import Foundation

class MovieREST {
    
    private static let basePath = "https://api.themoviedb.org/3"
    private static let API_KEY = "7d8f773c003172eb742122984b193864"
    
    private static let configuration:URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config
    }()
    
    private static let session = URLSession(configuration: <#T##URLSessionConfiguration#>)
    
    
    class func getMovieBy(id:Int) -> Movie{
        return Movie()
    }
    
    class func getMovieByTitle() -> [Movie] {
        return []
    }
    
    class func getLastRealeses() -> [Movie] {
        return []
    }
    
    class func getImageMovieURL(posterURL: String) -> String {
        let urlImage = "https://image.tmdb.org/t/p/w500\(posterURL)"
        return urlImage
    }
}
