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
    
    @IBOutlet weak var labelsInfo: UIView!
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
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.isUnreachable { (manager) in
            self.isReachable = false
            self.noConnection.isHidden = false
            self.activityIndicator.stopAnimating()
        }
        
        testConnection()
        
    }

    
    
    func loadNowPlaying(){
        
        if isReachable {
            
            MovieREST.getNowPlaying(onComplete: { (movies) in
                self.nowPlayingMovies = movies
                self.loadImagesNowPlaying(movies: movies)
                
                DispatchQueue.main.async {
                self.labelsInfo.isHidden = false
                   self.startAnimation()
                }
                
            }) { (error) in
                ErrorHelper.showMovieError(controller: self, error: error)
            }
        }
    }
    
    func startAnimation(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            
            self.showNextImage()
        })
        showNextImage()
    }
    
   
    
    func loadImagesNowPlaying(movies: [MovieDetail]){
        movies.forEach { (movie) in
            if let data = try? Data(contentsOf: movie.getPosterURL()!) {
                if let image = UIImage(data: data) {
                    self.imagesPlaying.append(image)
                    self.activityIndicator.stopAnimating()
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
            if self.moviesTopRated.count > 0 {
                return
            }
            self.selectionMoviesLabel.text = "↓ Top Rated Movies"
            self.noResultsLabel.alpha = 0
            self.isReachable = true
            self.noConnection.isHidden = true
            self.loadNowPlaying()
            self.loadTopRatedMovies()

        }
        
        
        
        
        network.reachability.whenReachable = { _ in
            UIView.animate(withDuration: 1, animations: {
                self.isReachable = true
                self.loadNowPlaying()
                self.loadTopRatedMovies()
                self.noConnection.isHidden = true
            })
        }
        network.reachability.whenUnreachable = { reachability in
            UIView.animate(withDuration: 1, animations: {
                self.isReachable = false
                self.noConnection.isHidden = false
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadTopRatedMovies(){
        self.activityIndicator.startAnimating()
        MovieREST.getTopRatedMovies(onComplete: { (movies) in
            DispatchQueue.main.async {
                self.moviesTopRated = movies
                self.collectionView.reloadData()
                
                self.collectionView.alpha = 1
                self.activityIndicator.stopAnimating()
            }
        }) { (error) in
            ErrorHelper.showMovieError(controller: self, error: error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationVC = segue.destination as? UINavigationController {
            if let detailVC = navigationVC.viewControllers.first as? MovieDetailViewController,
                let index = collectionView.indexPathsForSelectedItems?.first {
                    detailVC.idMovie = moviesTopRated[index.item].id
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
        
        if !isReachable {
            self.noConnection.isHidden = false
            return
        }
        self.collectionView.alpha = 0
        self.activityIndicator.startAnimating()
        
        MovieREST.getMovieByTitle(title: searchBar.text!, onComplete: { (movies) in
            self.moviesTopRated = movies
            DispatchQueue.main.async {
                self.searchBar.text = ""
                self.view.endEditing(true)
                self.collectionView.reloadData()
                
                if self.moviesTopRated.count == 0 {
                    UIView.animate(withDuration: 1, animations: {
                        self.noResultsLabel.alpha = 1
                        self.activityIndicator.stopAnimating()
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
        self.labelsInfo.isHidden = false
        
        
        UIView.animate(withDuration: 1.5, delay: 1, options: [], animations: {
            self.selectionMoviesLabel.alpha = 1
            self.collectionView.alpha = 1
            
        }) { (success) in
            let indexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
        }
        self.selectionMoviesLabel.text = "↓ your selection"
        self.activityIndicator.stopAnimating()
    }
    
}
    
    
    
    
    
    
    


