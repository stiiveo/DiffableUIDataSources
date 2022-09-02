//
//  CollectionViewController.swift
//  DiffableUIDataSources
//
//  Created by Jason Ou on 2022/9/2.
//

import UIKit

// MARK: - ViewModel

private extension CollectionViewController {
    
    final class Section: Hashable {
        let id = UUID()
        let title: String
        let items: [Item]
        
        init(title: String, items: [Item]) {
            self.title = title
            self.items = items
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: CollectionViewController.Section, rhs: CollectionViewController.Section) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    final class Item: Hashable {
        let id = UUID()
        let title: String
        let releaseYear: Int
        var isDetailsHidden: Bool
        
        init(title: String, releaseYear: Int, isDetailsHidden: Bool = true) {
            self.title = title
            self.releaseYear = releaseYear
            self.isDetailsHidden = isDetailsHidden
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: CollectionViewController.Item, rhs: CollectionViewController.Item) -> Bool {
            lhs.id == rhs.id
        }
    }
}

final class CollectionViewController: UIViewController {
    
    // Properties
    private var sections = [Section]()
    private lazy var dataSource = makeDataSource()
    
    // Typealias
    fileprivate typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, Item>
    fileprivate typealias CollectionViewCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    
    // UI Components
    private var collectionView: UICollectionView!
    
    // Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        resetData()
        configureLayout()
        applySnapshot()
    }
}

// MARK: - UI Config

private extension CollectionViewController {
    
    func configureLayout() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.delegate = self
    }
}

// MARK: - DataSource

private extension CollectionViewController {
    
    private func resetData() {
        self.sections = MovieSection.allMovieSections.map {
            .init(
                title: $0.title,
                items: $0.movies.map {
                    .init(title: $0.title,
                          releaseYear: $0.releaseYear,
                          isDetailsHidden: false)
                }
            )
        }
    }
    
    func makeDataSource() -> CollectionViewDataSource {
        let cellRegistration = CollectionViewCellRegistration { cell, indexPath, item in
            var contentConfig = cell.defaultContentConfiguration()
            contentConfig.text = item.title
            contentConfig.secondaryText = item.isDetailsHidden ? nil : String(item.releaseYear)
            contentConfig.image = UIImage(systemName: "film")
            cell.contentConfiguration = contentConfig
        }
        
        let dataSource = CollectionViewDataSource(collectionView: collectionView) { collectionView, indexPath, movie in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        return dataSource
    }
    
    func applySnapshot(withAnimation isAnimated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: isAnimated)
    }
}

// MARK: - CollectionView Delegate

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        item.isDetailsHidden.toggle()
        
        if #available(iOS 15, *) {
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.reconfigureItems([item])
            dataSource.apply(currentSnapshot)
        } else {
            applySnapshot()
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
