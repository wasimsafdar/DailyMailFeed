//
//  RSSReaderCell.swift
//  Article Reader
//
//  Created by Eng Waseem on 04/10/2017.
//  Copyright © 2017 Humma Embedded Consultancy and Development. All rights reserved.
//

import UIKit

class RSSReaderCell: UITableViewCell {

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articlePubDate: UILabel!
    
    //Set the cell elements 
    var item:XMLItem!{
        
        didSet{
        articleTitle.text = item.title
        articlePubDate.text = item.pubDate
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
