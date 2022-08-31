//
//  ONBoardingViewModel.swift
//  MVVM_News
//
//  Created by Sulfah on 06/04/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol ONBoardingViewModelInterface{
    var screenIndex: PublishSubject<Int> {get set}
    var element:BehaviorRelay<OnBoardingElement>{get}
    var isLastOnBoardingScreen:PublishSubject<Bool>{get}
    var numberOFOnboardingScreens:BehaviorRelay<Int>{get}
}



class ONBoardingViewModel:ONBoardingViewModelInterface{
    var numberOFOnboardingScreens: BehaviorRelay<Int>
    var isLastOnBoardingScreen: PublishSubject<Bool>
    var screenIndex: PublishSubject<Int>
    var element:BehaviorRelay<OnBoardingElement>
    var bag:DisposeBag!
    init(){
        bag = DisposeBag()
        screenIndex = PublishSubject()
        element = BehaviorRelay<OnBoardingElement>(value: OnBoardingElement(imageName: OBImages.surfing.rawValue, title: ""))
        isLastOnBoardingScreen = PublishSubject<Bool>()
        numberOFOnboardingScreens = BehaviorRelay<Int>(value: OnBoardingElement._NUM)
        bind()
    }
    private func bind(){
        screenIndex.asObservable().subscribe { [weak self] val in
            guard let self = self else {return}
            guard let val = val.element else {return}
            switch val{
            case 0:
                let element = OnBoardingElement(imageName: OBImages.surfing.rawValue, title: OBImages.surfing.rawValue)
                self.element.accept(element)
            case 1:
                let element = OnBoardingElement(imageName: OBImages.details.rawValue, title: OBImages.details.rawValue)
                self.element.accept(element)
            case 2:
                let element = OnBoardingElement(imageName: OBImages.search.rawValue, title: OBImages.search.rawValue)
                self.element.accept(element)
                
            default:
                self.element.accept(OnBoardingElement(imageName: "", title: ""))
            }
//            if val + 1 == OnBoardingElement._NUM {
//                self.isLastOnBoardingScreen.onNext(true)
//            }
        }.disposed(by: bag)
    }
    
    
}
