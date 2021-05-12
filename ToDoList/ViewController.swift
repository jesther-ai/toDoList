//
//  ViewController.swift
//  ToDoList
//
//  Created by Jesther Silvestre on 5/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    private let table:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    //global var of strings
    var items = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message:"Enter new to-do list item", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Add Item... "
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self]  _ in
            if let alert = alert.textFields?.first{
                if let text = alert.text, !text.isEmpty{
                    //enter todo list items
                    DispatchQueue.main.async {
                        var currentItem = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        
                        currentItem.append(text)
                        UserDefaults.standard.setValue(currentItem, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
        
    }
    
    
}
//MARK: - UITableViewDataSource
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
}

