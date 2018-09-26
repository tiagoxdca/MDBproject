//
//  MovieCell.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 11/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewMovie: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    
    
    func updateCell(movie: Movie){
        
        
        let image = UIImage(named: "placeholder")
        let url = movie.getMovieURL() ?? nil
        self.imageViewMovie.kf.setImage(with: url, placeholder: image)

        imageViewMovie.kf.indicatorType = .activity
        
        lbTitle.text = "\(movie.title!)"
    }
}
