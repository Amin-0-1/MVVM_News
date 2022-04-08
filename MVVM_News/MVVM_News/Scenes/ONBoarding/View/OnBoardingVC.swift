//
//  OnBoardingVC.swift
//  MVVM_News
//
//  Created by Sulfah on 06/04/2022.
//

import UIKit
import PaperOnboarding
import RxSwift
import RxRelay
class OnBoardingVC: UIViewController,PaperOnboardingDataSource{

    @IBOutlet private weak var uiSkipButton: UIButton!
    private var bag:DisposeBag!
    private var viewModel:ONBoardingViewModelInterface = ONBoardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
    }
    deinit{
        
    }

    func onboardingItemsCount() -> Int {
        return viewModel.numberOFOnboardingScreens.value
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        self.viewModel.screenIndex.onNext(index)
        let element = viewModel.element.value
        let title = element.title
        let desc = element.description
        
        let image = UIImage(named: element.imageName) ?? #imageLiteral(resourceName: "details")
        let bottomImage = UIImage(systemName: "checkmark.circle.fill")!
        
        let backGroundColor = UIColor(named: "backgroundColor") ?? UIColor.cyan
        let cornGreen = UIColor(named: "CornGreen") ?? UIColor.green
        
        return OnboardingItemInfo(informationImage: image
                                  , title: title.capitalized,
                                  description: desc,
                                  pageIcon: bottomImage,
                                  color: backGroundColor,
                                  titleColor: cornGreen,
                                  descriptionColor: cornGreen,
                                  titleFont: .monospacedSystemFont(ofSize: 25, weight: .bold),
                                  descriptionFont: .monospacedSystemFont(ofSize: 19, weight: .regular))
        
    }
    
    @IBAction func uiSkipButtonPressed(_ sender: Any) {
        let vc = ConfigurationsVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
