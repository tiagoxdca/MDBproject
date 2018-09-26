//
//  TrailerViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 17/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import AVKit

class TrailerViewController: UIViewController {
    
    var movieDetail: MovieDetail?
    var favoriteMovie: FavoriteMovie?
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    let network = NetworkManager.sharedInstance
    
    
    @IBOutlet weak var noTrailerLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var trailerView: WKWebView!
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testConnection()
        
        self.titleLabel.text = movieDetail?.title
        self.overViewLabel.text = movieDetail?.overview
        self.trailerView.navigationDelegate = self
        

        MovieREST.getMovieTrailer(id: (movieDetail?.id!)!, onComplete: { (trailer) in
            DispatchQueue.main.async {
                
                if let trailer = trailer {
                    self.preparePlayer(keyVideo: trailer.key!)
                    self.noTrailerLabel.alpha = 0
                } else {
                    self.noTrailerLabel.alpha = 1
                }
                
                
            }
        }) { (error) in
            print("Something wrong happen")
        }
    }
    
    

    
    

    func preparePlayer(keyVideo: String){
        
        if let url = URL(string: "https://www.youtube.com/embed/\(keyVideo)") {
            
            trailerView.load(URLRequest(url: url))

        }
    }
    
    fileprivate func testConnection() {
        network.reachability.whenUnreachable = { reachability in
            self.dismiss(animated: true, completion: nil)
        }
    }

}


extension TrailerViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
