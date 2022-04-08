//
//  ConfigurationsVC.swift
//  MVVM_News
//
//  Created by Sulfah on 07/04/2022.
//

import UIKit
import CountryPickerView
import RxCocoa
import RxSwift
import Toast
class ConfigurationsVC: UIViewController,ViewControllable{

    
    @IBOutlet private weak var uiFlagImage: UIImageView!
    @IBOutlet private weak var uiTextField: UITextField!
    @IBOutlet private weak var uiStack: UIStackView!
    @IBOutlet weak var uiInterestView: UICollectionView!
    
    @IBOutlet private weak var uiSubmitButton: UIButton!
    private var countryPickerView : CountryPickerView!
    private var viewModel:ConfigurationsViewModelInterface!
    private var bag:DisposeBag!
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
        viewModel = ConfigurationsViewModel()
        registerCollectionCell()
        configurePicker()
        bind()
    }
    
    private func bind(){
        viewModel.isValidSubmition.bind(to: uiSubmitButton.rx.isEnabled).disposed(by: bag)
        viewModel.loading.bind(to: view.rx.isUserInteractionEnabled).disposed(by: bag)
        viewModel.loading.subscribe{ [weak self] val in
            guard let self = self,let val = val.element else {return}
            if val{
                self.showLoading()
                
            }else{
                self.hideLoading()
            }
        }.disposed(by: bag)
        viewModel.saved.bind{
            StartingPoint.navigateToHome()
        }.disposed(by: bag)
        
    }
    private func registerCollectionCell(){
        let layout = self.uiInterestView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 90, height: 50)
        
        let nib = UINib(nibName: InterestCell._Name, bundle: nil)
        uiInterestView.register(nib, forCellWithReuseIdentifier: InterestCell._ID )
    }
    
    private func configurePicker(){
        countryPickerView = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.textColor = .label
        
        uiTextField.addTarget(self, action: #selector(onTextFieldPressed), for: .allTouchEvents)
        uiTextField.addTarget(self, action: #selector(onTextFieldPressed), for: .editingDidBegin)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTextFieldPressed))
        uiFlagImage.addGestureRecognizer(tapGesture)
        
        uiStack.layer.borderColor = UIColor.darkGray.cgColor
        uiStack.layer.borderWidth = 0.6
        uiStack.layer.cornerRadius = 12
        uiStack.layer.masksToBounds = true
     
        uiFlagImage.layer.cornerRadius = uiFlagImage.frame.height / 2
    }
    
    @objc func onTextFieldPressed(){
        countryPickerView.showCountriesList(from: self)
    }
    
    @IBAction func uiSubmit(_ sender: Any) {
        viewModel.submitted.onNext(true)
    }
}

extension ConfigurationsVC:CountryPickerViewDelegate,CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        uiTextField.resignFirstResponder()
        uiFlagImage.image = country.flag
        uiTextField.text = country.name + "( \(country.code) )"
        viewModel.choosedCountry.onNext(country.code)
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return viewModel.supportedTitle.value
    }
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        let allCodes = viewModel.preferedCountriesCodes.value
        let supportedCountries = countryPickerView.countries.filter { country in
            allCodes.contains(country.code.lowercased())
        }
        return supportedCountries
    }
    
    
}

extension ConfigurationsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.interestCount.value

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestCell._ID, for: indexPath) as? InterestCell else {fatalError("unable to deque cell")}
        cell.viewModel = self.viewModel
        viewModel.prepareFor(indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? InterestCell else {return}
        cell.onCellTapped()
        
        
    }
    
}
