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
class HomeVC: UIViewController, UISearchResultsUpdating ,UISearchControllerDelegate{
    
    private var viewModel:HomeViewModelInterface!
    private var bag:DisposeBag!
    @IBOutlet private weak var uiTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
        viewModel = HomeViewModel(remote: Remote())
        title = "INN"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureNavBar()
        bind()
        configureTable()
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
                self.viewModel.selectedInterest.onNext(category)
            }))
        }

        return UIMenu(title: "Categories", image: UIImage(systemName: "list.bullet.rectangle")!, children: actions)
    }
    private func bind(){
        viewModel.allNews.bind(to: uiTableView.rx.items){ table,index,element in
            guard let cell = table.dequeueReusableCell(withIdentifier: NewsCell._ID) as? NewsCell else {fatalError("unable to dequeue cell")}
            cell.configureCell(element: element)
            return cell

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
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search for something eg CNN"
        
        navigationItem.searchController = sc
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
    }
    let array = [
        "UUID().uuidStringasdfasdf asdfasdfasdf asdfasdfgasdf asdfasdfasd UUID().uuidStringasdfasdf asdfasdfasdf asdfasdfgasdf asdfasdfasd ",
        "UUID().uuidStringasdfasdf asdfasdfasdf asdfasdfgasdf asdfasdfasd ",
        "ass"
    ]

}

//extension HomeVC:{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell._ID) as? NewsCell else {fatalError("unable to dequeue")}
//        cell.uiDesc.text = array[indexPath.row]
//        cell.uiDesc.textColor = .white
//        cell.uiImage.image = UIImage(named: "details")
//        return cell
//    }
//}
