//
//  ConfigurationsViewModel.swift
//  MVVM_News
//
//  Created by Sulfah on 07/04/2022.
//

import Foundation
import RxSwift
import RxRelay
protocol ConfigurationsViewModelInterface{
    var supportedTitle : BehaviorRelay<String>{get}
    var preferedCountriesCodes: BehaviorRelay<[String]>{get}
    
    var interestCount: BehaviorRelay<Int>{get}
    var singleInterest: PublishSubject<String>{get}
    func prepareFor(indexPath : IndexPath)
    
    var selected: PublishSubject<String>{get set}
    var deselected: PublishSubject<String>{get set}
    var choosedCountry: BehaviorSubject<String>{get set}
    var isValidSubmition: PublishSubject<Bool>{get}
    var submitted:PublishSubject<Bool>{get set}
    var loading:PublishSubject<Bool>{get}
    var saved: PublishSubject<Void>{get}
}

class ConfigurationsViewModel:ConfigurationsViewModelInterface{
    var saved: PublishSubject<Void>
    
    var loading: PublishSubject<Bool>
    
    var submitted: PublishSubject<Bool>
    
    var isValidSubmition: PublishSubject<Bool>
    
    var choosedCountry: BehaviorSubject<String>
    
    var selected: PublishSubject<String>
    var deselected: PublishSubject<String>
    private var allInterests: BehaviorSubject<[String]>
    var singleInterest: PublishSubject<String>
    var interestCount: BehaviorRelay<Int>
    private var categories: BehaviorRelay<[String]>
    
    var supportedTitle: BehaviorRelay<String>
    var preferedCountriesCodes: BehaviorRelay<[String]>

    private var bag:DisposeBag!
    init(){
        bag = DisposeBag()
        supportedTitle = BehaviorRelay(value: SupportedCountryCodes._ID)
        preferedCountriesCodes = BehaviorRelay(value: SupportedCountryCodes.getAllCodes())
        
        interestCount = BehaviorRelay(value: Categories.allCases.count)
        categories = BehaviorRelay(value: Categories.getAllCategories())
        singleInterest = PublishSubject()
        
        selected = PublishSubject()
        deselected = PublishSubject()
        allInterests = BehaviorSubject(value: [])
        choosedCountry = BehaviorSubject(value: "")
        isValidSubmition = PublishSubject()
        submitted = PublishSubject()
        loading = PublishSubject()
        saved = PublishSubject()
        bind()
    }
    
    private func bind(){
        selected.subscribe{[weak self] val in
            guard let self = self else {return}
            guard let val = val.element else {return}
            guard let lastStat = try? self.allInterests.value() else {return}
            self.allInterests.onNext(lastStat + [val])
            
        }.disposed(by: bag)
        deselected.subscribe{[weak self] val in
            guard let self = self else {return}
            guard let val = val.element else {return}
            guard var lastStat = try? self.allInterests.value() else {return}
            lastStat.removeAll{$0 == val}
            self.allInterests.onNext(lastStat)

        }.disposed(by: bag)
        
        Observable.combineLatest(deselected, choosedCountry).bind{ [weak self] _,choosedCountry in
            guard let self = self else {return}
            self.combineSelections(choosedCountry: choosedCountry)
        }.disposed(by: bag)
        Observable.combineLatest(selected, choosedCountry ).bind{[weak self] _,choosedCountry in
            guard let self = self else {return}
            self.combineSelections(choosedCountry: choosedCountry)
        }.disposed(by: bag)
        submitted.subscribe{ [weak self] val in
            guard let self = self,let val = val.element else {return}
            if val{
                self.finalizeConfigurations()
            }
        }.disposed(by: bag)
    }
    
    
    func prepareFor(indexPath: IndexPath) {
        singleInterest.onNext(categories.value[indexPath.row]) 
        
    }
    private func combineSelections(choosedCountry:String){
        guard let allInterests = try? self.allInterests.value() else {return}
        if allInterests.isEmpty || choosedCountry.isEmpty{
            self.isValidSubmition.onNext(false)
        }else{
            self.isValidSubmition.onNext(true)
        }
    }
    private func finalizeConfigurations(){
        loading.onNext(true)
        guard let country = try? choosedCountry.value(), let interests = try? allInterests.value() else {loading.onNext(false);return}
        MyUserDefaults.set(value: country, forKey: .country)
        

        guard let encodedInterests = try? JSONEncoder().encode(interests) else {
            loading.onNext(false)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else {return}
            self.saved.onNext(())
            MyUserDefaults.set(value: true, forKey: .isFirstInit)
            self.loading.onNext(false)
        }
        
        MyUserDefaults.set(value: encodedInterests, forKey: .interests)
        
    }
}
