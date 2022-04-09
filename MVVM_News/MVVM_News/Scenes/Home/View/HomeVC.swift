//
//  HomeVC.swift
//  MVVM_News
//
//  Created by Sulfah on 06/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
class HomeVC: UIViewController , UISearchBarDelegate,ViewControllable{
    
    private var viewModel:HomeViewModelInterface!
    private var bag:DisposeBag!
    @IBOutlet private weak var uiTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
        viewModel = HomeViewModel(datasource: Repo(local: LocalDataSource(), remote: RemoteDatasource()))
        configureTable()
        bind()
        title = "INN"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureNavBar()
        setupSearchBar()

    }
    
    private func configureNavBar(){
        let btn = UIBarButtonItem(systemItem: .compose, primaryAction: nil, menu: createMenu())
        btn.changesSelectionAsPrimaryAction = true
        navigationItem.rightBarButtonItem = btn
    }
    private func createMenu()->UIMenu{
        var actions = [UIAction]()
        let categories = viewModel.interests.value
        categories.forEach { category in
            actions.append(UIAction(title: category, image: nil, handler: {[weak self] action in
                guard let self = self else {return}
                self.viewModel.selectedInterest.accept(category)
            }))
        }

        return UIMenu(title: "Categories", image: UIImage(systemName: "list.bullet.rectangle")!, children: actions)
    }
    private func bind(){
        viewModel.allNews.bind(to: uiTableView.rx.items){ (table: UITableView, index: Int, element: Article) in
            guard let cell = table.dequeueReusableCell(withIdentifier: NewsCell._ID) as? NewsCell else {fatalError("unable to dequeue cell")}
            cell.configureCell(element: element)
            return cell

        }.disposed(by: bag)
        
        
        uiTableView.rx.modelSelected(Article.self).subscribe{ (model) in
            guard let model = model.element else {return}
            let vc = DetailsVC()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: bag)
        
        viewModel.showLoading.bind{ [weak self] in
            guard let self = self else {return}
            self.showLoading()
        }.disposed(by: bag)
        
        viewModel.hideLoading.bind{ [weak self] in
            guard let self = self else {return}
            self.hideLoading()
        }.disposed(by: bag)
        
    }
    private func configureTable(){
        uiTableView.rowHeight = UITableView.automaticDimension
        uiTableView.estimatedRowHeight = 600
        let nib = UINib(nibName: NewsCell._Name, bundle: nil)
        uiTableView.register(nib, forCellReuseIdentifier: NewsCell._ID)
    }
    func setupSearchBar() {
        
        let sc = UISearchController(searchResultsController: nil)
//        sc.delegate = self
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search for something eg CNN"
        
        navigationItem.searchController = sc
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch.onNext(())
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.rx.text.bind(to: viewModel.searchObserver).disposed(by: bag)
    }

}
