//
//  ViewController.swift
//  DiffableUIDataSources
//
//  Created by Jason Ou on 2022/8/28.
//

import UIKit

final class ViewController: UIViewController {
    
    // Properties
    private var movieSections = MovieSection.allMovieSections
    private lazy var dataSource = makeDataSource()
    
    // Value Types
    typealias DataSource = UITableViewDiffableDataSource<MovieSection, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MovieSection, Movie>
    
    // UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Movies"
        searchBar.backgroundColor = .systemBackground
        return searchBar
    }()
    
    // Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        applySnapshot(animatingDifferences: false)
    }

}

// MARK: - Private Methods

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
        tableView.backgroundColor = .systemBackground
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        tableView.delegate = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(false)
    }
    
    func makeDataSource() -> DataSource {
        // Bind the table view to the data source which provides the configured table view cell.
        let datasource = DataSource(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = movie.title
            contentConfig.secondaryText = String(movie.releaseYear)
            contentConfig.textProperties.numberOfLines = 0
            contentConfig.image = UIImage(systemName: "film")
            contentConfig.imageProperties.tintColor = .systemTeal
            cell.contentConfiguration = contentConfig
            cell.contentView.backgroundColor = .systemGroupedBackground
            
            return cell
        }
        
        return datasource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(movieSections)
        movieSections.forEach { section in
            snapshot.appendItems(section.movies, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.movieSections = filteredMovieSections(for: searchBar.text)
        applySnapshot()
    }
    
    private func filteredMovieSections(for query: String?) -> [MovieSection] {
        let sections = MovieSection.allMovieSections
        guard
            let query = query,
            !query.isEmpty
        else {
            return sections
        }
        
        var filteredSections = [MovieSection]()
        
        for section in sections {
            if section.title.lowercased().contains(query.lowercased()) {
                filteredSections.append(section)
                continue
            }
            
            var movieFilteredSection = section
            movieFilteredSection.movies = movieFilteredSection.movies.filter { movie in
                movie.title.lowercased().contains(query.lowercased())
            }
            if !movieFilteredSection.movies.isEmpty {
                filteredSections.append(movieFilteredSection)
            }
        }
        
        return filteredSections
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var contentConfig = UIListContentConfiguration.groupedHeader()
        contentConfig.text = self.movieSections[section].title
        contentConfig.textProperties.font = .preferredFont(forTextStyle: .headline)

        let contentView = UIListContentView(configuration: contentConfig)
        return contentView
    }
    

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.height {
//            movies.append(contentsOf: top10Movies)
//            applySnapshot(movies: movies, section: .top10)
//        }
//    }
}
