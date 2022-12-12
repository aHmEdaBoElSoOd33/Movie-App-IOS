//
//  YTCell.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 08/12/2022.
//

import UIKit
import youtube_ios_player_helper_swift

class YTCell: UICollectionViewCell {
    var key = Youtube()
    
    @IBOutlet weak var trailer: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        trailer.load(videoId: key)
        
    }
}
