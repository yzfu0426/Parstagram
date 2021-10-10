//
//  FeedTableViewCell.swift
//  Parstagram
//
//  Created by 傅羽竹 on 2021/10/10.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userProfile: UIButton!
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
