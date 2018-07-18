//
//  MovieREST.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 12/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum MovieError{
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

class MovieREST {
    
    private static let basePath = "https://api.themoviedb.org/3"
    private static let API_KEY = "7d8f773c003172eb742122984b193864"
    
    private static let configuration:URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 60
        config.httpMaximumConnectionsPerHost = 10
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    
    
    //MARK: METHODS
    class func getMovieDetailsById(id: Int, onComplete: @escaping (MovieDetail) -> Void, onError: @escaping (MovieError) -> Void){
        
        guard let url = getUrlMovieDetail(id: id) else { onError(.url); return}
        let dataTask = session.dataTask(with: url){ (data:Data?, response: URLResponse?, error:Error?) in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do{
                        let movieDetail = try JSONDecoder().decode(MovieDetail.self, from:data)
                        
                        onComplete(movieDetail)
                        
                    } catch {
                        onError(.invalidJSON)
                    }
                    
                } else{
                    onError(.responseStatusCode(code: response.statusCode))
                }
            }else {
                onError(.taskError(error: error!))
            }
        }
        
        dataTask.resume()

    }
    
    class func getMovieByTitle(title: String?, onComplete: @escaping ([MovieDetail]) -> Void, onError: @escaping (MovieError) -> Void) {
        guard let url = self.getURLMovieByTitle(title: title) else {
            onError(.url)
            return
        }
        
        let dataTask = session.dataTask(with: url){ (data:Data?, response: URLResponse?, error:Error?) in
            
            
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do{
                        let movieDetail = try JSONDecoder().decode(MovieResponseDetail.self, from:data).results
                        onComplete(movieDetail)
                        
                    } catch {
                        onError(.invalidJSON)
                    }
                    
                } else{
                    onError(.responseStatusCode(code: response.statusCode))
                }
            }else {
                onError(.taskError(error: error!))
            }
        }
        
        dataTask.resume()
    }
    
    class func getNowPlaying(onComplete: @escaping ([MovieDetail]) -> Void, onError: @escaping (MovieError) -> Void){
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {return}
        
        Alamofire.request(url).response { (response) in
            
            
            guard let data = response.data,
                let movies = try? JSONDecoder().decode(MovieResponseDetail.self, from: data).results else {
                    onError(.invalidJSON)
                    return
                }
            onComplete(movies)
            
        }
        
    }
    
    class func getTopRatedMovies(onComplete: @escaping ([MovieDetail]) -> Void, onError: @escaping (MovieError) -> Void){
        
        guard let url = self.getTopRatedURL() else {
            onError(.url)
            return}
        
        Alamofire.request(url).response { (response) in
            
            
            guard let data = response.data,
                let movies = try? JSONDecoder().decode(MovieResponseDetail.self, from: data).results else {
                    onError(.invalidJSON)
                    return
            }
            
            onComplete(movies)
            
        }
    }
    
    class func getLastReleases(onComplete: @escaping ([Movie]) -> Void, onError: @escaping (MovieError) -> Void) {
       
        guard let url = self.lastReleasesURL() else {
            onError(.url)
            return}
        
        let dataTask = session.dataTask(with: url) { (data:Data?, response: URLResponse?, error:Error?) in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do{
                        let movies = try JSONDecoder().decode(MovieResponse.self, from:data).results
                        
                        onComplete(movies)
                        
                    } catch {
                        onError(.invalidJSON)
                    }
                    
                } else{
                    onError(.responseStatusCode(code: response.statusCode))
                }
            }else {
                onError(.taskError(error: error!))
            }
        }
        
        dataTask.resume()
        
    }
    
    
    class func getMovieTrailer(id:Int, onComplete: @escaping (Trailer?) -> Void, onError: @escaping (MovieError) -> Void){
        
        guard let url = self.getUrlTrailer(id: id) else {
            onError(.url)
            return}
        
        Alamofire.request(url).response { (response) in
            guard let data = response.data,
                let trailer = try? JSONDecoder().decode(TrailerResponse.self, from: data).results! else {
                    onError(.invalidJSON)
                    return
                }
            if let trailer = trailer.first {
                onComplete(trailer)
            } else {
                onComplete(nil)
            }
            
        }
    }
    
    
    
    class func getURLMovieByTitle(title:String?) -> URL? {
        let name = title?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        if let name = name {
            let stringURL = "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&query=\(name)&page=1"
            guard let url = URL(string: stringURL) else {return nil}
            return url
        }
        return nil
    }
    
    class func getUrlTrailer(id: Int) -> URL? {
        let stringURL = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=7d8f773c003172eb742122984b193864&language=en-US"
        
        guard let url = URL(string: stringURL) else {return nil}
        return url
    }
    
    class func getTopRatedURL() -> URL?{
        let stringURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(API_KEY)&language=en-US&page=1"
        
        guard let url = URL(string: stringURL) else {return nil}
        return url
    }
    
    class func getUrlMovieDetail(id:Int) -> URL?{
        let stringURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=7d8f773c003172eb742122984b193864&language=en-US"
        
        guard let url = URL(string: stringURL) else {return nil}
        return url
    }
    
    class func getImageMovieURL(posterURL: String) -> String {
        let urlImage = "https://image.tmdb.org/t/p/w500\(posterURL)"
        return urlImage
    }
    
    class func lastReleasesURL() -> URL?{
        
        let urlComponents = NSURLComponents()
        
        
        urlComponents.scheme = "https";
        urlComponents.host = "api.themoviedb.org";
        urlComponents.path = "/3/discover/movie";
        
        let api_key = NSURLQueryItem(name: "api_key", value: self.API_KEY)
        let language = NSURLQueryItem(name: "language", value: "en-US")
        let sort_by = NSURLQueryItem(name: "sort_by", value: "popularity.desc")
        let include_adult = NSURLQueryItem(name: "include_adult", value: "true")
        let include_video = NSURLQueryItem(name: "include_video", value: "true")
        let numberOfPages = NSURLQueryItem(name: "page", value: "1")
        
        urlComponents.queryItems = [api_key, language, sort_by, include_adult, include_video, numberOfPages] as [URLQueryItem]
        
        return urlComponents.url
    }
    
   
    
    
    
    
    
}
