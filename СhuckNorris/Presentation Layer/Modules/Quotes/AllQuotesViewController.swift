//
//  AllQuotesViewController.swift
//  СhuckNorris
//
//  Created by Matsulenko on 09.09.2023.
//

import Foundation
import UIKit
import RealmSwift

final class AllQuotesViewController: UIViewController {
    
    private let category: String?
    
    let cellReuseIdentifier = "cell"
    
    private var data: [String] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(category: String? = nil) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupTable()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupData()
        tableView.reloadData()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupTable() {
        setupData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupData() {
        data = []
        let realm = try! Realm()
        let objects = realm.objects(QuoteObject.self).sorted(byKeyPath: "downloadedAt", ascending: false)
        
        if category == nil {
            
            data = objects.map { Quote(quoteObject: $0).value }
            
        } else if category == "" {
            
            let quotes = objects.map { Quote(quoteObject: $0) }
            for i in quotes {
                if i.categories.isEmpty {
                    data.append(i.value)
                }
            }
            
        } else {
            
            let quotes = objects.map { Quote(quoteObject: $0) }
            for i in quotes {
                if i.categories.contains(category!) {
                    data.append(i.value)
                }
            }
            
        }
    }
    
    private func setupView() {
        if category == nil {
            title = "All quotes"
        } else if category == "" {
            title = "Without category"
        } else {
            title = category
        }
        view.backgroundColor = .systemGray6
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
}


extension AllQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = data.count
        if number == 0 {
            return 1
        } else {
            return number
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell?)!
        var text = "There are no donloaded quotes"
        
        if data.count > 0 {
            text = self.data[indexPath.row]
        }
            
        cell.textLabel?.text = text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        cell.isUserInteractionEnabled = false
        
        return cell
    }
}
