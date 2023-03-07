//
//  AddNewLocationView.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import UIKit

protocol AnyAddNewLocationView: AnyObject {
    var presenter: AnyAddNewLocationPresenter? { get set }
}

class AddNewLocationView: UIViewController, AnyAddNewLocationView {
    var presenter: AnyAddNewLocationPresenter?
    
    lazy var cityTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type any city name..."
        tf.layer.borderWidth = 1
        tf.layer.borderColor = .init(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 5
        tf.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 35))
        tf.leftViewMode = .always
        return tf
    }()
    
    lazy var searchCityButton: UIButton = {
        let search = UIButton()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        search.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        return search
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isHidden = true
        return tv
    }()
    
    @objc func didTapSearch() {
        print(#function)
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        title = "Add new location"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        cityTextfield.delegate = self
        
        setCityTextFieldAndSearchCityButton()
        
        configTableView()
        setTableViewConstraints()
    }
    
    private func setCityTextFieldAndSearchCityButton() {
        view.addSubview(searchCityButton)
        view.addSubview(cityTextfield)
        
        NSLayoutConstraint.activate([
            searchCityButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchCityButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchCityButton.heightAnchor.constraint(equalToConstant: 35),
            searchCityButton.widthAnchor.constraint(equalToConstant: 35),
            
            cityTextfield.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            cityTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cityTextfield.trailingAnchor.constraint(equalTo: searchCityButton.leadingAnchor, constant: -10),
            cityTextfield.centerYAnchor.constraint(equalTo: searchCityButton.centerYAnchor),
            cityTextfield.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setTableViewConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cityTextfield.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: cityTextfield.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: searchCityButton.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension AddNewLocationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let userInput = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            if userInput.count > 0 {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
            }
        }
        
        return true
    }
}

extension AddNewLocationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
    }
}
