//
//  TrailerViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 17/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class TrailerViewController: UIViewController {
    
    var movieDetail: MovieDetail!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    let network = NetworkManager.sharedInstance
    
    
    @IBOutlet weak var noTrailerLabel: UILabel!
    @IBOutlet weak var playerTrailer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testConnection()
        
        self.titleLabel.text = movieDetail.title
        self.overViewLabel.text = movieDetail.overview
        

        MovieREST.getMovieTrailer(id: movieDetail.id!, onComplete: { (trailer) in
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
        
        if let url = URL(string: "https://www.youtube.com/embed/\(keyVideo)"){

            player = AVPlayer(url: url)
            playerController = AVPlayerViewController()
            playerController.player = player
            playerController.showsPlaybackControls = true
            playerController.player?.play()
            playerController.view.frame = playerTrailer.bounds
            playerTrailer.addSubview(playerController.view)
            
        }
    }
    
    fileprivate func testConnection() {
        network.reachability.whenUnreachable = { reachability in
            self.dismiss(animated: true, completion: nil)
        }
    }

}
