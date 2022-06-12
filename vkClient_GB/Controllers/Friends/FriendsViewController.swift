//
//  FriendsViewController.swift
//  VKClient
//
//  Created by Дмитрий Скок on 21.10.2021.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let reuseIdentifierCustom = "reuseIdentifierCustom"
    let fromFriendsToGallerySegue = "fromFriendsToGallery"
    
    var friends: [FriendsSection] = []
    var filteredFriends: [FriendsSection] = []
    var lettersOfNames: [String] = []
    var service = FriendsServiceManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.view.addGestureRecognizer(tapRecognizer)
        tapRecognizer.cancelsTouchesInView = false
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCustom)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        fetchFriends()
    }
    
    @objc func tapFunction() {
        self.view.endEditing(true)
    }
}
// MARK: - UITableViewDataSource
extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends[section].data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = friends[section]
        return String(section.key)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCustom, for: indexPath) as? CustomTableViewCell
        else {
            return UITableViewCell()
        }
        
        let section = filteredFriends[indexPath.section]
        let photo = section.data[indexPath.row].photo50
        let name = section.data[indexPath.row].firstName
        cell.titleLabel.text = name
        
        DispatchQueue.main.async { [weak self] in
            self?.service.loadImage(url: photo) { image in
                cell.avatarImageView.image = image
            }
        }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension FriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let vc = storyboard.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController,
            let indexPathSection = tableView.indexPathForSelectedRow?.section,
            let indexPathRow = tableView.indexPathForSelectedRow?.row
        else {
            return
        }
        let section = filteredFriends[indexPathSection]
        let friendId = section.data[indexPathRow].id
        vc.friendId = String(friendId)
        show(vc, sender: nil)
    }
}
//MARK: - UISearchBarDelegate
extension FriendsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends = []
        
        if searchText == "" {
            filteredFriends = friends
        } else {
            for section in friends {
                for (_, friend) in section.data.enumerated() {
                    if friend.firstName.lowercased().contains(searchText.lowercased()) {
                        var searchedSection = section
                        
                        if filteredFriends.isEmpty {
                            searchedSection.data = [friend]
                            filteredFriends.append(searchedSection)
                            break
                        }
                        var found = false
                        for (sectionIndex, filteredSection) in filteredFriends.enumerated() {
                            if filteredSection.key == section.key {
                                filteredFriends[sectionIndex].data.append(friend)
                                found = true
                                break
                            }
                        }
                        if !found {
                            searchedSection.data = [friend]
                            filteredFriends.append(searchedSection)
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
}
// MARK: - Private
private extension FriendsViewController {
    
    func loadLetters() {
        for user in friends {
            lettersOfNames.append(String(user.key))
        }
    }
    
    func fetchFriends() {
        service.loadFriends { [weak self] friends in
            guard let self = self else { return }
            self.friends = friends
            self.filteredFriends = friends
            self.loadLetters()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

