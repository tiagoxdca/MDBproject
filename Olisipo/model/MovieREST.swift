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
    class func getMovieDetailsById(movie:Movie, onComplete: @escaping (MovieDetail) -> Void, onError: @escaping (MovieError) -> Void){
        
        guard let url = getUrlMovieDetail(id: movie.id) else { onError(.url); return}
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
        guard let url = self.getURLMovieTitle(title: title) else {
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
                        print(movieDetail)
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
    
    class func getURLMovieTitle(title:String?) -> URL? {
        guard let name = title?.replacingOccurrences(of: " ", with: "") else {return nil}
        
        let stringURL = "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&query=\(name)&page=1"
        
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
    
    class func configureMessageError(error: MovieError) -> String{
        var stringError = ""
        switch error {
        case .invalidJSON:
            stringError = "Json is invalid..."
        case .url:
            stringError = "Your url is invalid..."
        default:
            stringError = "There was some problem with your json..."
        }
        
        return stringError
    }
    
    
    
    
    
}
