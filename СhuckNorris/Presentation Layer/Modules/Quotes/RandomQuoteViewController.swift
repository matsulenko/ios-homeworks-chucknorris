//
//  RandomQuoteViewController.swift
//  СhuckNorris
//
//  Created by Matsulenko on 09.09.2023.
//

import Foundation
import UIKit

final class RandomQuoteViewController: UIViewController {
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        randomQuote()
    }
    
    private func setupView() {
        title = "Random quote"
        view.backgroundColor = .systemGray6
    }
    
    private func addSubviews() {
        view.addSubview(quoteLabel)
    }

    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            quoteLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            quoteLabel.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor, constant: -20)
        ])
    }
    
    private func randomQuote() {
        
        let url = URL(string: "https://api.chucknorris.io/jokes/random")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if let error {
                print(error.localizedDescription)
            }
            
            guard let data else { return }
            let decoder = JSONDecoder()
            
            do {
                let quote = try decoder.decode(Quote.self, from: data)
                RealmService().saveQuote(quote)
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote.value
                }                
            } catch {

            }
            
        }.resume()
    }
    
}


    
    
    
