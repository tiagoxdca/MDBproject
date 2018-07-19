//
//  ViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 11/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import SystemConfiguration

class LastReleasesViewController: UIViewController {
    
    let network = NetworkManager.sharedInstance
   
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgNoConnection: UIImageView!
    
    
    var movies: [Movie] = [Movie]()
    var movie: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preparePresentation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        testConnection()
    }
    
    func loadAnimation(){
        UIView.animate(withDuration: 1, animations: {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.alpha = 0
            self.collectionView.alpha = 1
            
        })
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationVC = segue.destination as? UINavigationController {
            if let detailVC = navigationVC.viewControllers.first as? MovieDetailViewController,
                let index = collectionView.indexPathsForSelectedItems?.first {
                detailVC.movie = self.movies[index.item]
            }
        }
    }
    
    
    
    fileprivate func testConnection() {
        NetworkManager.isReachable { (manager) in
            self.showLastReleases()
            self.imgNoConnection.alpha = 0
            self.collectionView.alpha = 1
        }
        NetworkManager.isUnreachable { (manager) in
            self.imgNoConnection.alpha = 1
            self.collectionView.alpha = 0
            self.activityIndicator.stopAnimating()
        }
        
        network.reachability.whenReachable = { _ in
            self.showLastReleases()
            self.imgNoConnection.alpha = 0
            
        }
        
        network.reachability.whenUnreachable = { reachability in
            UIView.animate(withDuration: 1, animations: {
                self.collectionView.alpha = 0
                self.imgNoConnection.alpha = 1
            })
        }
    }
    
    
    fileprivate func showLastReleases() {
        MovieREST.getLastReleases(onComplete: { (movies) in
            self.movies = movies
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                self.loadAnimation()
            }
            
        }) { (error) in
            ErrorHelper.showMovieError(controller: self, error: error)
        }
    }
    
    fileprivate func preparePresentation() {
        let width = (view.frame.size.width - 6) / 3
        //let height = width * 1.5
        let height = (view.frame.size.height) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        self.collectionView.alpha = 0
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
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let rotationAngleInRadians = 90.0 * CGFloat(Double.pi/180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
}




