//
//  MovieError.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 18/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import Foundation
import UIKit

class ErrorHelper {
    
    class func showMovieError(controller: UIViewController, error: MovieError){
        let alert = UIAlertController(title: "You have some error?", message: "\(configureMessageError(error: error))", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    class func configureMessageError(error: MovieError) -> String{
        var stringError = ""
        switch error {
        case .invalidJSON:
            stringError = "Json is invalid..."
        case .url:
            stringError = "Your url is invalid..."
        case .noInternet:
            stringError = "No Internet connection..."
        default:
            stringError = "There was some problem with your json..."
        }
        
        return stringError
    }
    
}
