//
//  ViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 11/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit

class LastReleasesViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var movies: [Movie] = [Movie]()
    var movie: Movie?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 6) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        self.collectionView.alpha = 0
        
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MovieREST.getLastReleases(onComplete: { (movies) in
            self.movies = movies
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                self.loadAnimation()
                
            }
            
        }) { (error) in
            self.showMovieError(error: error)
        }
    }
    
    func loadAnimation(){
        UIView.animate(withDuration: 3, animations: {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.alpha = 0
            self.collectionView.alpha = 1
            self.lbError.alpha = 0
        })
    }
    
    func showMovieError(error: MovieError){
        let alert = UIAlertController(title: "You have some error?", message: "\(MovieREST.configureMessageError(error: error))", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationVC = segue.destination as? UINavigationController {
            if let detailVC = navigationVC.viewControllers.first as? MovieDetailViewController,
                let index = collectionView.indexPathsForSelectedItems?.first {
                detailVC.movie = self.movies[index.item]
            }
        }
        
//        if let vc = segue.destination as? MovieDetailViewController,
//            let index = collectionView.indexPathsForSelectedItems?.first {
//               vc.movie = self.movies[index.item]
//        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
    }

}

extension LastReleasesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionCell
        movie = movies[indexPath.row]
        cell.updateCell(movie: movie!)
        return cell
    }
    
    
}


