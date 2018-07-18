//
//  MovieTableViewCell.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var moviePosterImageView: UIImageView!
    @IBOutlet fileprivate weak var movieTitleLabel: UILabel!
    @IBOutlet fileprivate weak var movieReleaseDateLabel: UILabel!
    @IBOutlet fileprivate weak var movieScoreLabel: UILabel!
    
    @IBOutlet fileprivate weak var contentContainer: UIView!
    @IBOutlet fileprivate weak var backgroundContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with movie: Movie){
        self.movieTitleLabel.text = movie.title
        self.movieReleaseDateLabel.text = movie.releaseDate.formatDateAsString()
        self.movieScoreLabel.text = String(format: "%.1f", movie.movieScore.doubleValue)
        
        //Setup poster image
        self.moviePosterImageView.sd_setImage(with: URL(string: movie.posterImageUrl), completed: nil)
        
        //Setup customs views changs
        self.setupCustomsView()
    }
    
    fileprivate func setupCustomsView(){
        
        self.backgroundContent.layer.masksToBounds = false
        self.backgroundContent.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        self.backgroundContent.layer.shadowOffset = CGSize(width: 0.7, height: 2.0)
        self.backgroundContent.layer.shadowOpacity = 0.7
        self.backgroundContent.layer.shadowRadius = 4.0
        
        //A little round for corners & shadow content
        self.contentContainer.layer.cornerRadius = 10.0
        self.contentContainer.clipsToBounds = true
        
        //circle shape for score
        self.movieScoreLabel.layer.cornerRadius = self.movieScoreLabel.frame.size.width / 2
        self.movieScoreLabel.clipsToBounds = true
    }
}
