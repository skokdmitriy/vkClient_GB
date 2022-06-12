//
//  MyGroupViewController.swift
//  VKClient
//
//  Created by Дмитрий Скок on 21.10.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

final class MyGroupViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let fromAllGroupsToMyGroupsSegue = "fromAllGroupsToMyGroups"
    let reuseIdentifierCustom = "reuseIdentifierCustom"
    
    private let service = GroupService()
    private lazy var realm = RealmCacheService()
    
    private var groupResponse: Results<Group>? {
        realm.read(Group.self)
    }
    
    private var groupFirebase = [FirebaseGroup]()
    private let ref = Database.database().reference(withPath: "Communities")
    
    private var notificationToken: NotificationToken?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationGroupToken()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCustom)
        tableView.delegate = self
        tableView.dataSource = self
        getUserGroupList()
        ref.observe(.value, with: { snapshot in
            var communities: [FirebaseGroup] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let group = FirebaseGroup(snapshot: snapshot) {
                    communities.append(group)
                }
                print("Обновлен список добавленых групп")
                communities.forEach { print($0.groupName) }
                print("Колличество групп\(communities.count)")
            }
        })
    }
    
    @IBAction func addGroup(_ segue: UIStoryboardSegue) {
        if segue.identifier == "addGroupSegue" {
            guard let allCommunitiesController = segue.source as? AllGroupViewController else { return }
            if let indexPath = allCommunitiesController.tableView.indexPathForSelectedRow{
                let community = allCommunitiesController.filteredGroups[indexPath.row]
                service.addGroup(idGroup: community.id) { [weak self]  result in
                    switch result {
                    case .success(let success):
                        if success.response == 1 {
                            let fireGroup = FirebaseGroup(groupName: community.name, groupId: community.id)
                            let commRef = self?.ref.child(community.name.lowercased())
                            commRef?.setValue(fireGroup.toAnyObject())
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupResponse?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCustom, for: indexPath) as? CustomTableViewCell
        else {
            return UITableViewCell()
        }
        if let groups = groupResponse {
            cell.configure(group: groups[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction (at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action, view, completion) in
            if let community = self?.groupResponse?[indexPath.row] {
                self?.service.leaveGroup(idGroup: community.id) { result in
                    switch result {
                    case .success(let success):
                        if success.response == 1 {
                            print("Вы вышли из группы")
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                }
            }
        }
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash.fill")
        
        return action
    }
}

private extension MyGroupViewController {
    
    func getUserGroupList() {
        service.loadGroups { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func createNotificationGroupToken() {
        notificationToken = groupResponse?.observe{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .initial(let groupsData):
                print("init with \(groupsData.count) groups")
            case .update(let groups,
                         deletions: let deletions,
                         insertions: let insertions,
                         modifications: let modifications):
                print("""
new count \(groups.count)
deletions \(deletions)
insertions \(insertions)
modifications \(modifications)
""")
                let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }
                
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
                    self.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
                    self.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
                    self.tableView.endUpdates()
                }
            case .error(let error):
                print("\(error)")
            }
        }
    }
}
