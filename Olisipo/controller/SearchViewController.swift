//
//  SearchViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 13/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController {
    
    
    let network = NetworkManager.sharedInstance
    var moviesTopRated: [MovieDetail] = []
    var nowPlayingMovies: [MovieDetail] = []
    var moviesSearched : [MovieDetail] = []
    var imagesPlaying: [UIImage] = []
    var indexImage: Int = 0
    var timer: Timer!
    var isReachable: Bool = false
    
    
    
    

    
    @IBOutlet weak var noConnection: UIView!
    
    @IBOutlet weak var cTop: NSLayoutConstraint!
    
    @IBOutlet weak var selectionMoviesLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var latestMovieLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testConnection()
        self.loadNowPlaying()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isReachable {
            self.noConnection.alpha = 0
            self.loadTopRatedMovies()
        } else {
            self.noConnection.alpha = 1
        }
        self.selectionMoviesLabel.text = "↓ Top Rated Movies"
        noResultsLabel.alpha = 0
        
    }

    
    
    func loadNowPlaying(){
        
        if isReachable {
            MovieREST.getNowPlaying(onComplete: { (movies) in
                self.nowPlayingMovies = movies
                self.loadImagesNowPlaying(movies: movies)
                DispatchQueue.main.async {
                   self.startAnimation()
                }
                
            }) { (error) in
                ErrorHelper.showMovieError(controller: self, error: error)
            }
        }
    }
    
    func startAnimation(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true, block: { (timer) in
            
            self.showNextImage()
        })
        showNextImage()
    }
    
   
    
    func loadImagesNowPlaying(movies: [MovieDetail]){
        movies.forEach { (movie) in
            if let data = try? Data(contentsOf: movie.getPosterURL()!) {
                if let image = UIImage(data: data) {
                    self.imagesPlaying.append(image)
                }
            }
        }
    }
    
    
    
    
    
    func showNextImage(){
        
        let image1 = imagesPlaying[indexImage]
        let image2 = imagesPlaying[indexImage + 1]
        let image3 = imagesPlaying[indexImage + 2]
        
        self.image1.image = image1
        self.image2.image = image2
        self.image3.image = image3
        self.image1.alpha = 0
        self.image2.alpha = 0
        self.image3.alpha = 0
        self.cTop.constant = 145
        self.view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 1.5) {
            self.image1.alpha = 1
            self.image2.alpha = 1
            self.image3.alpha = 1
            self.cTop.constant = 0
            self.view.layoutIfNeeded()
            
        }
        if indexImage == (nowPlayingMovies.count - 5) {
            indexImage = 0
        } else {
            indexImage += 3
        }
        
    }
    
    fileprivate func testConnection() {
        
        NetworkManager.isReachable { (manager) in
            self.isReachable = true
        }
        
        NetworkManager.isUnreachable { (manager) in
            self.isReachable = false
        }
        
        
        network.reachability.whenReachable = { _ in
            UIView.animate(withDuration: 1, animations: {
                self.isReachable = true
                self.loadNowPlaying()
                self.loadTopRatedMovies()
                self.noConnection.alpha = 0
            })
        }
        network.reachability.whenUnreachable = { reachability in
            UIView.animate(withDuration: 1, animations: {
                self.isReachable = false
                 self.noConnection.alpha = 1
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadTopRatedMovies(){
        MovieREST.getTopRatedMovies(onComplete: { (movies) in
            DispatchQueue.main.async {
                self.moviesTopRated = movies
                self.collectionView.reloadData()
                self.collectionView.alpha = 1
            }
        }) { (error) in
            ErrorHelper.showMovieError(controller: self, error: error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationVC = segue.destination as? UINavigationController {
            if let detailVC = navigationVC.viewControllers.first as? MovieDetailViewController,
                let index = collectionView.indexPathsForSelectedItems?.first {
                    detailVC.movieDetail = moviesTopRated[index.item]
            }
        }
    }
        
}

extension SearchViewController: UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieSearchCollectionViewCell
       
            let movie = moviesTopRated[indexPath.row]
            cell.updateCell(movie: movie)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return moviesTopRated.count
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        MovieREST.getMovieByTitle(title: searchBar.text!, onComplete: { (movies) in
            self.moviesTopRated = movies
            DispatchQueue.main.async {
                self.searchBar.text = ""
                self.view.endEditing(true)
                self.collectionView.reloadData()
                if self.moviesTopRated.count == 0 {
                    UIView.animate(withDuration: 2, animations: {
                        self.noResultsLabel.alpha = 1
                    })
                } else {
                    self.updateLabelResults()
                }
            }
        }) { (error) in
            
            ErrorHelper.showMovieError(controller: self, error: error)
            
        }
    }
    
    
    fileprivate func updateLabelResults() {
        self.collectionView.alpha = 0
        self.noResultsLabel.alpha = 0
        self.selectionMoviesLabel.alpha = 0
        UIView.animate(withDuration: 1.5, animations: {
            self.selectionMoviesLabel.alpha = 1
            self.collectionView.alpha = 1
        })
        self.selectionMoviesLabel.text = "↓ your selection"
    }
    
}
    
    
    
    
    
    
    


