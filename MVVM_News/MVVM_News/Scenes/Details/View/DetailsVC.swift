//
//  DetailsVC.swift
//
//
//  Created by Amin on 17/07/2021.
//

import UIKit
import SDWebImage

class DetailsVC: UIViewController {

    var model: Article!
    var viewModel: DetailsViewModelInterface!
    
    @IBOutlet var uiImage: UIImageView!
    @IBOutlet var uiImageView: UIView!
    @IBOutlet var uiTitle: UILabel!
    @IBOutlet var uiAuthor: UILabel!
    @IBOutlet var uiPublishDate: UILabel!
    @IBOutlet var uiDescription: UILabel!
    @IBOutlet var uiSourceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailsViewModel()
        
        setupImage()
        setupDescription()
        setupSourceButton()
        
        uiTitle.text = model.title
        uiAuthor.text = model.author ?? UUID().uuidString
        uiPublishDate.text = model.publishedAt
        
        title = model.author
    }
    func setupImage() {
        
        uiImageView.layer.borderWidth = 0.3
        uiImageView.layer.cornerRadius = 25
        uiImage.layer.cornerRadius = 25
        uiImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        uiImageView.layer.shadowRadius = 1
        uiImageView.layer.shadowOpacity = 0.8
        uiImageView.layer.masksToBounds = false
        
        uiImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        uiImage.sd_setImage(with: URL(string: model.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder"))
        
    }

    func setupDescription() {
        guard let description = model.articleDescription else { return }
        guard let content = model.content else { return }


        let fullString = NSMutableAttributedString()

        let desc = NSAttributedString(string: "\(description)\n\n", attributes: [NSAttributedString.Key.foregroundColor :UIColor.darkGray ])

        let cont = NSAttributedString(string: content, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        fullString.append(desc)
        fullString.append(cont)
        
        uiDescription.attributedText = fullString
    }
    
    func setupSourceButton() {
//        guard let _ = model.url else { uiSourceButton.isHidden = true ; return }
        
        uiSourceButton.layer.cornerRadius = uiSourceButton.layer.frame.height / 2
        uiSourceButton.layer.shadowOpacity = 0.8
        uiSourceButton.layer.shadowRadius = 1
        uiSourceButton.layer.shadowOffset = CGSize(width: 5, height: 5)
    }

    @IBAction func uiSourcebtn(_ sender: UIButton) {
//        guard let url = itemNews.url else { return }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut]) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { (_) in
            sender.transform = .identity
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self = self else { return }

                let newsSourceWebPage = NewsSourceVC()
                newsSourceWebPage.url = self.model.url
                self.navigationController?.pushViewController(newsSourceWebPage, animated: true)
            }
        }
    }
    
}
