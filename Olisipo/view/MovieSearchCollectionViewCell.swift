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
    
    

    @IBOutlet weak var trailingCell: NSLayoutConstraint!
    
    @IBOutlet weak var imgMovie: UIImageView!
    
    @IBOutlet weak var movieSearchTitle: UILabel!
    func updateCell(movie: MovieDetail){
        
        guard let url = movie.getPosterURL() else {
            return
        }

        movieSearchTitle.text = movie.title
        imgMovie.kf.indicatorType = .activitão
	if (gaitas)
        	imgMovie.kf.setImage(with: URCOISAS)
	else
		imgMovie.kf.setImage(with: URCENAS)
        imgMovie.layer.cornerRadius = imgMovie.frame.size.width / 2
        imgMovie.layer.borderCor = UIColor.red.cgColor   
    }

    
    
    
    
    
}
