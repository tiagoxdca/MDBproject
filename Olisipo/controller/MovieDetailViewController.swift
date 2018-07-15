//
//  MovieDetailViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 12/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    var movieDetail: MovieDetail!
    
    
    @IBOutlet weak var imgMovie: UIImageView!
    
    @IBOutlet weak var titleMovie: UILabel!
    
    
    @IBOutlet weak var percentage: UILabel!
    
   
    @IBOutlet weak var dropBackMovie: UIImageView!
    
    @IBOutlet weak var popularity: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overViewMovie: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.fetchMovieDetail()
        
        
        
        
    }
    
    func fetchMovieDetail(){
        MovieREST.getMovieDetailsById(movie: movie, onComplete: { (movieDetail) in
            self.movieDetail = movieDetail
            print("\(movieDetail.title)  -  \(movieDetail.id)")
            DispatchQueue.main.async {
                self.setupDetails()
                self.navigationItem.title = "\(movieDetail.title)"
            }
        }) { (error) in
            print("Ocorreu um erro ao carregar o filme")
        }
    }
    
    func setupDetails() {
        
        self.imgMovie.load(url: movieDetail.getPosterURL()!)
        self.dropBackMovie.load(url: movieDetail.getBackDropURL()!)
        self.titleMovie.text = "\(movieDetail.title)"
        self.overViewMovie.text = "\(movieDetail.overview)"
        self.popularity.text = "\(movieDetail.popularity) votes."
        self.percentage.text = "\(movieDetail.vote_average)/10"
        self.releaseDate.text = "\(movieDetail.release_date)"
        
       
    }
    
    

    
    
    @IBAction func dismiss(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
