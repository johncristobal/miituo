//
//  TutoThreeViewController.swift
//  miituo
//
//  Created by John A. Cristobal on 27/04/17.
//  Copyright © 2017 John A. Cristobal. All rights reserved.
//

import UIKit
import MediaPlayer

class TutoThreeViewController: UIViewController {
    
    @IBOutlet var viewvideo: UIView!

    var player3: AVPlayer?
    let videoURL: NSURL = Bundle.main.url(forResource: "onb3", withExtension: "mp4")! as NSURL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //blur...
        /*
         let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
         let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = view.bounds
         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         self.view.addSubview(blurEffectView)
         */
        
        //self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        // Do any additional setup after loading the view.
        /*let path = Bundle.main.path(forResource: "miituoonb12", ofType:"mp4")
         let url = NSURL.fileURL(withPath: path!)
         self.moviePlayer = MPMoviePlayerController(contentURL: url)
         if let player = self.moviePlayer {
         player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
         player.view.sizeToFit()
         player.scalingMode = MPMovieScalingMode.fill
         player.isFullscreen = true
         player.controlStyle = MPMovieControlStyle.none
         player.movieSourceType = MPMovieSourceType.file
         player.repeatMode = MPMovieRepeatMode.one
         player.play()
         self.viewone.addSubview(player.view)
         }*/
        
        //viewone.alpha = 0.75;
        //viewone.layer.zPosition = 0;
        
        // begin implementing the avplayer
        
        player3 = AVPlayer(url: videoURL as URL)
        player3?.actionAtItemEnd = .none
        player3?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player3)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //playerLayer.zPosition = -1
        
        playerLayer.frame = viewvideo.frame
        
        self.viewvideo.layer.addSublayer(playerLayer)
        
        
        // add observer to watch for video end in order to loop video
        
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player)
        
        // if video ends, will restart
        
        /*func playerItemDidReachEnd() {
            player3!.seek(to: kCMTimeZero)
        }*/
        
    }

    override func viewDidAppear(_ animated: Bool) {
        player3?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
