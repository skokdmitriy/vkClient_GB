//
//  AllGroupViewController.swift
//  VKClient
//
//  Created by Дмитрий Скок on 21.10.2021.
//

import UIKit

class AllGroupViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//    let reuseIdentifierCustom = "reuseIdentifierCustom"
//    let fromAllGroupsToMyGroupsSegue = "fromAllGroupsToMyGroups"
    
    
    private let service = GroupService()
    private let serviceImage = FriendsServiceManager()
    var filteredGroups: [Group] = []
    
//    var count = Int()
//    var didSelectIndexGroup: Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCustom)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        configSearchBar()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AllGroupViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cellall", for: indexPath) as? AllGroupsCell
        else {
            return UITableViewCell()
        }
        cell.configure(group: filteredGroups[indexPath.row])
        return cell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return CGFloat(80)
//    }
}
//MARK: - UISearchBarDelegate
extension AllGroupViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.isEmpty ? "" : searchText
        filteredGroups = []
        service.loadGroupSearch(searchText: text) { [weak self] result in
            switch result {
            case .success(let group):
                self?.filteredGroups = group
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func configSearchBar() {
        searchBar.placeholder = "Поиск групп"
    }
}
