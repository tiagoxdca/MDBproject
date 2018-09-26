//
//  FavoriteMovieCell.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 03/08/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import Kingfisher

class FavoriteMovieCell: UITableViewCell {

    
    
    @IBOutlet weak var imgFavorite: UIImageView!
    
    @IBOutlet weak var titleFavorite: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    func updateCell(movie: FavoriteMovie){
        
        
        if let image = movie.poster as? UIImage {
            imgFavorite.image = image
        } else {
            imgFavorite.image = UIImage(named: "favorite_3x")
        }
        
        imgFavorite.kf.indicatorType = .activity
        
        titleFavorite.text = "\(movie.title!)"
        releaseDate.text = "\(movie.release_date!)"
    }

    

}
