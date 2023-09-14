//
//  CategorizedQuotesViewController.swift
//  СhuckNorris
//
//  Created by Matsulenko on 09.09.2023.
//

import Foundation
import UIKit
import RealmSwift

final class CategorizedQuotesViewController: UIViewController {
    
    let cellReuseIdentifier = "cell"
    
    private var data: [String] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
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
        let realm = try! Realm()
        let objects = realm.objects(QuoteCategory.self).sorted(byKeyPath: "name")
        data = objects.map { Category(quoteCategory: $0.name).name }
    }
    
    private func setupView() {
        title = "By category"
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
    
    @objc
    private func openQuotes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
                if self.tableView.cellForRow(at: swipedIndexPath) != nil {
                    let section = swipedIndexPath.section
                    var category = ""
                    if section > 0 {
                        category = data[(section - 1)]
                    }
                    let quotesVC = AllQuotesViewController(category: category)
                    navigationController?.pushViewController(quotesVC, animated: true)
                }
            }
        }
    }
}

extension CategorizedQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell?)!
        var text = "without category"
        
        if indexPath.section > 0 {
            text = self.data[indexPath.section - 1]
        }
            
        cell.textLabel?.text = text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        cell.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openQuotes(recognizer:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
}
