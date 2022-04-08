//
//  HomeViewModel.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelInterface{
    var allNews:BehaviorRelay<[Article]>{get}
    var interests:BehaviorRelay<[String]>{get}
    var selectedInterest:PublishSubject<String>{get}
}
class HomeViewModel:HomeViewModelInterface{
    var selectedInterest: PublishSubject<String>
    
    var interests: BehaviorRelay<[String]>
    
    var allNews: BehaviorRelay<[Article]>
    
    
    private var remote:RemoteInterface!
    private var country:String
    private lazy var selectedCategory:String = {
        return categories[0].rawValue
    }()
    private var categories:[Categories]
    private var bag:DisposeBag!
    init(remote:RemoteInterface){
        self.remote = remote
        bag = DisposeBag()
        allNews = BehaviorRelay(value: [])
        interests = BehaviorRelay(value: [])
        selectedInterest = PublishSubject()
        country = ""
        categories = []
        getCountry()
        getInterests()
        remote.fetch(categories: categories, country: country)
        
        bind()
    }
    private func getCountry(){
        guard let country = MyUserDefaults.getValue(forKey: .country) as? String else {return}
        self.country = country
    }
    private func getInterests(){
        guard let data = MyUserDefaults.getValue(forKey: .interests) as? Data else {return}
        guard let decodedData = try? JSONDecoder().decode([String].self, from: data) else {return}
        interests.accept(decodedData)
        categories = decodedData.compactMap{Categories(rawValue: $0)}
    }
    
    private func bind(){
        remote.articles.bind{[weak self] val in
            guard let self = self else {return}
            self.allNews.accept(self.allNews.value + val)
        }.disposed(by: bag)
        selectedInterest.bind{ [weak self] category in
            guard let self = self else {return}
            self.selectedCategory = category
        }.disposed(by: bag)
    }
}
