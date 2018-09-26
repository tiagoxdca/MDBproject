//
//  MovieDetailViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 12/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData


class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var containerFavorite: UIView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    
    var movieDetail: MovieDetail?
    var favoriteMovie: FavoriteMovie?
    let network = NetworkManager.sharedInstance
    var isReachable: Bool?
    var idMovie: Int?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var dropBackMovie: UIImageView!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overViewMovie: UILabel!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            testConnection()
    }

    func loadFavoriteMovie(movie: FavoriteMovie) {
        self.activityIndicator.stopAnimating()
        navigationItem.title = "\(movie.title!)"
        self.titleMovie.text = "\(movie.title!)"
        self.overViewMovie.text = "\(movie.overview!)"
        self.popularity.text = "\(movie.popularity) votes"
        self.percentage.text = "\(movie.vote_average)/10"
        self.releaseDate.text = "\(movie.release_date!)"
        if let image = movie.backdrop as? UIImage {
            self.dropBackMovie.image = image
        }
        if let image = movie.poster as? UIImage {
            self.imgMovie.image = image
        }
        self.btnFavorite.alpha = 0
        
        
    }
    
    func fetchMovieDetail(idMovie: Int){
        self.activityIndicator.startAnimating()
        
            MovieREST.getMovieDetailsById(id: idMovie, onComplete: { (movieDetail) in
                self.movieDetail = movieDetail
                
                
                DispatchQueue.main.async {
                    self.setupDetails()
                    self.navigationItem.title = "\(movieDetail.title!)"
                    self.imgMovie.layer.borderWidth = 1
                    self.imgMovie.layer.cornerRadius = 4
                    self.imgMovie.layer.borderColor = UIColor.white.cgColor
                    self.btnFavorite.alpha = 1
                    self.playButton.alpha = 1
                    self.activityIndicator.stopAnimating()
                    
                }
            }) { (error) in
                ErrorHelper.showMovieError(controller: self, error: error)
                self.activityIndicator.stopAnimating()
            }
        
    }
    
    func setupDetails() {
        
        if let movieDetail = movieDetail {
            let image = UIImage(named: "placeholder")
            let posterUrl = movieDetail.getPosterURL()
            self.imgMovie.kf.setImage(with: posterUrl, placeholder: image)
            
            let backdropURL = movieDetail.getBackDropURL()
            self.dropBackMovie.kf.setImage(with: backdropURL, placeholder: image)
            self.titleMovie.text = "\(movieDetail.title!)"
            self.overViewMovie.text = "\(movieDetail.overview!)"
            self.popularity.text = "\(movieDetail.popularity!) votes"
            self.percentage.text = "\(movieDetail.vote_average!)/10"
            self.releaseDate.text = "\(movieDetail.release_date!)"
            self.activityIndicator.stopAnimating()
        }
    }
    
    fileprivate func fetchMovieDetail() {
        
        if let idMovie = self.idMovie {
            self.fetchMovieDetail(idMovie: idMovie)
            self.checkIfExistsInFavorites(id: "\(idMovie)")
        }
        
        
    }
    
    fileprivate func testConnection() {
        
        if movieDetail != nil {return}
        
        NetworkManager.isReachable { (manager) in
            self.isReachable = true
            self.fetchMovieDetail()
            
        }
        
        NetworkManager.isUnreachable { (manager) in
            if let movieId = self.idMovie {
                if let favoriteMovie = self.favoriteMovie {
                    self.loadFavoriteMovie(movie: favoriteMovie)
                }
                
                self.checkIfExistsInFavorites(id: "\(movieId)")
                self.playButton.alpha = 0
                self.isReachable = false
            } else {
                self.isReachable = false
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        network.reachability.whenReachable = { _ in
            self.isReachable = true
            self.fetchMovieDetail()
            return
        }
        
        network.reachability.whenUnreachable = { reachability in
            
            self.activityIndicator.stopAnimating()
            if let favoriteMovie = self.favoriteMovie {
                self.isReachable = false
                self.loadFavoriteMovie(movie: favoriteMovie)

                self.containerFavorite.alpha = 0
            } else {
                
                self.isReachable = false
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func checkIfExistsInFavorites(id: String){
        
        let request : NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            if let favorite = result.first {
                self.loadFavoriteMovie(movie: favorite)
            }
            if result.count > 0 {
                self.containerFavorite.alpha = 0
            } else {
                self.containerFavorite.alpha = 1
            }
        } catch {
            print("Failed")
        }
    }
    
    
    @IBAction func addToFavorites(_ sender: Any) {
        
        self.btnFavorite.alpha = 0
        if let movieDetail = self.movieDetail {
            let newFavorite = FavoriteMovie(context: self.context)
            newFavorite.id = "\(movieDetail.id!)"
            newFavorite.title = movieDetail.title
            newFavorite.poster = imgMovie.image
            newFavorite.backdrop = dropBackMovie.image
            newFavorite.overview = movieDetail.overview
            newFavorite.release_date = movieDetail.release_date
            newFavorite.popularity = movieDetail.popularity!
            newFavorite.vote_average = movieDetail.vote_average!
        }
        
        self.saveFavorite()
        
    }
    
    func saveFavorite(){
        do {
            try context.save()
            self.containerFavorite.alpha = 0
        } catch {
            print("Error saving context...")
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailToTrailer" {
            let vc = segue.destination as! TrailerViewController
               vc.movieDetail = self.movieDetail
        }
    }
}
