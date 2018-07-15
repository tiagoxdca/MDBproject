//
//  MovieCell.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 11/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewMovie: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    func updateCell(movie: Movie){
        
        guard let url = movie.getMovieURL() else {
            return
        }
        imageViewMovie.load(url: url)
        lbTitle.text = "\(movie.title)"
        
       
        
        
    }
}
