//
//  ViewController.swift
//  Mixer-TableAnimation
//
//  Created by Artyom on 10.11.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var data: [String] = (1...30).map { "Строка \($0)" }
    var isSelected: [Bool] = Array(repeating: false, count: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGray5
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 60, width: view.frame.size.width, height: 80))
        view.addSubview(navBar)
        navBar.barTintColor = .systemGray5
        let navItem = UINavigationItem(title: "Task 4")
        let shuffleButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(Mixer))
        navItem.rightBarButtonItem = shuffleButton
        navBar.setItems([navItem], animated: false)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.accessoryType = isSelected[indexPath.row] ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelected[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            selectedCell.accessoryType = isSelected[indexPath.row] ? .checkmark : .none
        }
        
        if indexPath.row > 0 && isSelected[indexPath.row] {
            tableView.beginUpdates()
            let firstIndexPath = IndexPath(row: 0, section: 0)
            tableView.moveRow(at: indexPath, to: firstIndexPath)
            data.insert(data.remove(at: indexPath.row), at: 0)
            isSelected.insert(isSelected.remove(at: indexPath.row), at: 0)
            tableView.endUpdates()
        }
    }
    
    @objc func Mixer() {
        var newIndexes = Array(0..<data.count)
        newIndexes.shuffle()
        
        tableView.performBatchUpdates({
            for (index, _) in data.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                let newIndex = newIndexes[index]
                let newIndexPath = IndexPath(row: newIndex, section: 0)
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
            
            data = newIndexes.map { data[$0] }
            isSelected = newIndexes.map { isSelected[$0] }
        }, completion: nil)
    }
}
