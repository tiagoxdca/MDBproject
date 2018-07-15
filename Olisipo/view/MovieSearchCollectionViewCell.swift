//
//  MovieSearchCollectionViewCell.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 14/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import Kingfisher

class MovieSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgMovie: UIImageView!
    
    func updateCell(movie: MovieDetail){
        
        guard let url = movie.getPosterURL() else {
            return
        }
        imgMovie.kf.indicatorType = .activity
        imgMovie.kf.setImage(with: url)
        imgMovie.layer.cornerRadius = imgMovie.frame.size.width / 2
        imgMovie.layer.borderColor = UIColor.red.cgColor
        imgMovie.layer.borderWidth = 5
        
        
        
        
    }
    
    
    
}
