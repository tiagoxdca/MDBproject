//
//  MovieDetailViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 12/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import Kingfisher


class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    var movieDetail: MovieDetail!
    let network = NetworkManager.sharedInstance
    
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
        testConnection()
        if let movie = movie {
            self.fetchMovieDetail(idMovie: movie.id)
        } else {
            self.fetchMovieDetail(idMovie: movieDetail.id!)
        }
    }
    
    func fetchMovieDetail(idMovie: Int){
        MovieREST.getMovieDetailsById(id: idMovie, onComplete: { (movieDetail) in
            self.movieDetail = movieDetail
            
            DispatchQueue.main.async {
                self.setupDetails()
                self.navigationItem.title = "\(movieDetail.title!)"
            }
        }) { (error) in
            ErrorHelper.showMovieError(controller: self, error: error)
        }
    }
    
    func setupDetails() {
        
        if let posterUrl = movieDetail.getPosterURL() {
            self.imgMovie.kf.indicatorType = .activity
            
            let placeholder = UILabel()
            placeholder.text = "No Image!"
            self.imgMovie.kf.setImage(with: posterUrl, placeholder: placeholder as? Placeholder)
            self.activityIndicator.stopAnimating()
            
        }
        
        if let backdropURL = movieDetail.getBackDropURL() {
            self.dropBackMovie.load(url: backdropURL)
        }
        
        
        self.titleMovie.text = "\(movieDetail.title!)"
        self.overViewMovie.text = "\(movieDetail.overview!)"
        self.popularity.text = "\(movieDetail.popularity!) votes."
        self.percentage.text = "\(movieDetail.vote_average!)/10"
        self.releaseDate.text = "\(movieDetail.release_date!)"
    }
    
    fileprivate func testConnection() {
        network.reachability.whenUnreachable = { reachability in
            self.dismiss(animated: true, completion: nil)
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
