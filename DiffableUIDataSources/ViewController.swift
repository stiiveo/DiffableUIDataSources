//
//  ViewController.swift
//  DiffableUIDataSources
//
//  Created by Jason Ou on 2022/8/28.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case movie
    }
    
    struct Movie: Hashable {
        let title: String
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    private var movies = [Movie]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Movies"
        return searchBar
    }()
    
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        movies = top10Movies
        configureInterface()
        applySnapshot(movies: movies, section: .movie)
    }

}

private extension ViewController {
    
    func configureInterface() {
        configureSearchBar()
        configureTableView()
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        searchBar.delegate = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(false)
    }
    
    func makeDataSource() -> DataSource {
        // Bind the table view to the data source which provides the configured table view cell.
        let source = DataSource(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = movie.title
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = .systemGroupedBackground
            return cell
        }
        return source
    }
    
    func applySnapshot(movies: [Movie], section: Section, animatingDiff: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([section])
        snapshot.appendItems(movies, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: animatingDiff)
    }
    
    var top10Movies: [Movie] {
        [
            Movie(title: "Top Gun: Maverick"),
            Movie(title: "Jurassic World Dominion"),
            Movie(title: "Doctor Strange in the Multiverse of Madness"),
            Movie(title: "Minions: The Rise of Gru"),
            Movie(title: "The Batman"),
            Movie(title: "Thor: Love and Thunder"),
            Movie(title: "The Battle at Lake Changjin II"),
            Movie(title: "Moon Man"),
            Movie(title: "Fantastic Beasts: The Secrets of Dumbledore"),
            Movie(title: "Sonic the Hedgehog 2")
        ]
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movies = filteredMovies(for: searchBar.text)
        applySnapshot(movies: movies, section: .movie)
    }
    
    private func filteredMovies(for query: String?) -> [Movie] {
        let movies = top10Movies
        guard let query = query, !query.isEmpty else { return movies }
        return movies.filter {
            $0.title.lowercased().contains(query.lowercased())
        }
    }
}
