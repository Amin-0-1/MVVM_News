//
//  InterestCell.swift
//  MVVM_News
//
//  Created by Sulfah on 07/04/2022.
//

import UIKit
import RxSwift
class InterestCell: UICollectionViewCell {

    static let _ID = "InterestCellID"
    static let _Name = "InterestCell"
    
    @IBOutlet private weak var uiLabel: UILabel!
    @IBOutlet private weak var uiImage: UIImageView!
    
    private var isSelect:Bool!
    private var bag:DisposeBag!
    override var bounds: CGRect{
        didSet{
            layoutIfNeeded()
        }
    }
    
    var viewModel:ConfigurationsViewModelInterface!{
        didSet{
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSelect = false
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 0.6
    }

    func configure(){
        
        bag = DisposeBag()
        viewModel.singleInterest.subscribe{ interest in
            guard let interest = interest.element else {return}
            self.uiLabel.text = interest
            self.bag = nil
        }.disposed(by: bag)
        
    }
    
    func onCellTapped(){
        isSelect = !isSelect
        
        if isSelect{
            self.backgroundColor = .systemGreen
            guard let image = UIImage(systemName: ImageSelection.selected.rawValue) else {return}
            self.uiImage.image = image
            guard let str = uiLabel.text else {return}
            viewModel.selected.onNext(str)
        }else{
            self.backgroundColor = UIColor(named: "backgroundColor")
            guard let image = UIImage(systemName: ImageSelection.notSelected.rawValue) else {return}
            self.uiImage.image = image
            guard let str = uiLabel.text else {return}
            viewModel.deselected.onNext(str)
        }
    }
    
}
