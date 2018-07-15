//
//  SearchViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 13/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var movies: [MovieDetail] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMovies()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMovies(){
        
        MovieREST.getMovieByTitle(title: "SpiderMan", onComplete: { (movies) in
            
            print(movies)
            
            
        }) { (error) in
            print(error)
        }
        
        

        
    }
    

    

}

extension SearchViewController: UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieSearchCollectionViewCell
        let movie = movies[indexPath.row]
        cell.updateCell(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
}
