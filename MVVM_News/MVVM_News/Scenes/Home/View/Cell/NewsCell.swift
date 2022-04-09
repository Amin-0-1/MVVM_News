//
//  NewsCell.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import UIKit
import SDWebImage
class NewsCell: UITableViewCell {
    static let _ID = "NewsCellID"
    static let _Name = "NewsCell"
    @IBOutlet weak var uiView: UIView!
    @IBOutlet  weak var uiImage: UIImageView!
    @IBOutlet  weak var uiDesc: UILabel!
    
    func configureCell(element:Article){
        uiDesc.text = element.articleDescription ?? UUID().description
        
        
        uiImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        uiImage.sd_imageIndicator?.startAnimatingIndicator()
        guard let urlStr = element.urlToImage, let url = URL(string: urlStr) else {return}
        uiImage.sd_setImage(with: url, placeholderImage: UIImage(named: "searchX"), options: .forceTransition) { image, error, cache, url in
            self.uiImage.sd_imageIndicator?.stopAnimatingIndicator()
        }
        
        uiImage.layer.cornerRadius = 8
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 0.6
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.shadowColor = UIColor.darkGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
