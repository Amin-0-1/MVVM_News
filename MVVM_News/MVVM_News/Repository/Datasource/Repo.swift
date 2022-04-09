//
//  Datasource.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import RxSwift
import RxRelay
protocol Datasource{
    func fetch()
}

protocol RepoInterface:Datasource{
    var articles:PublishSubject<[Article]> {get}
    var category:BehaviorRelay<String>{get set}
    var country:BehaviorRelay<String>{get set}
}
class Repo:RepoInterface{
    var country: BehaviorRelay<String>
    
    var category: BehaviorRelay<String>
    
    var articles: PublishSubject<[Article]>
    
    private var local: MyRealmInterface!
    private var remote: RemoteInterface!
    private var bag:DisposeBag!
    init(local:MyRealmInterface,remote:RemoteInterface){
        self.local = local
        self.remote = remote
        bag = DisposeBag()
        articles = PublishSubject()
        category = BehaviorRelay(value: "")
        country = BehaviorRelay(value: "")
        bind()
    }
    func bind(){
        country.bind{[weak self] val in
            guard let self = self else {return}
            self.remote.country.accept(val)
            self.local.country.accept(val)
        }.disposed(by: bag)
        category.bind{ [weak self] val in
            guard let self = self else {return}
            self.remote.category.accept(val)
            self.local.category.accept(val)
        }.disposed(by: bag)
        local.allData.bind{[weak self] val in
            guard let self = self else {return}
            self.articles.onNext(val)
        }.disposed(by: bag)
        remote.articles.bind{ [weak self] val in
            guard let self = self else {return}
            self.local.saveNewsItems(items: val)
            self.articles.onNext(val)
        }.disposed(by: bag)
    }
    func fetch() {
        local.getLastHitTime().bind{[weak self] val in
            guard let self = self else {return}
            guard let val = val else { self.globalFetch() ; return }
            
            let valid = self.checkValidDateToHit(withOld:val)
            
            if valid{
                self.globalFetch()
            }else{
                self.localFetch()
            }
            
        }.disposed(by: bag)
    }
    private func localFetch(){
        local.fetch()
    }
    private func globalFetch(){
        remote.fetch()
        self.saveLastTime()
    }
    private func saveLastTime(){
        local.saveLastTime.onNext(())
    }
    private func checkValidDateToHit(withOld date:Date)->Bool{
        let diffComponents = Calendar.current.dateComponents([.minute], from: date, to: Date())
        guard let mins = diffComponents.hour else {return false}
        
        return mins >= Constants.refeshTime ? true : false
    
    }

}

