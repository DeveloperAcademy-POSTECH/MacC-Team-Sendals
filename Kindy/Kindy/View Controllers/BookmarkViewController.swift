//
//  BookmarkViewController.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/23.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    enum Section: Hashable {
        case bookMark
    }
    
    var dummyData: [Bookstore] = [
        Bookstore(images: nil, name: "달팽이 책방1", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방2", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방3", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방4", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방5", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10))
    ]
    
    private var filterdItem = [Bookstore]()
    
    private let searchController = UISearchController()
    
    private lazy var bookMarkCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Bookstore>!
    
    private var filteredItemSanpshot: NSDiffableDataSourceSnapshot<Section, Bookstore> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Bookstore>()
        snapshot.appendSections([.bookMark])
        snapshot.appendItems(filterdItem)
        
        return snapshot
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "북마크"
        setupSearchController()
        setupCollectionView()
    
        configureDataSource()
        
    }
    // 서치컨트롤러 설정
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // 컬렉션뷰 설정
    private func setupCollectionView() {
        view.addSubview(bookMarkCollectionView)
        bookMarkCollectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.identifier)
        bookMarkCollectionView.setCollectionViewLayout(createLayout(), animated: false)
        bookMarkCollectionView.showsVerticalScrollIndicator = false
        bookMarkCollectionView.frame = view.bounds
    }
    
    // CollectionView layout 지정
    func createLayout() -> UICollectionViewLayout {
        // fractionalSize -> Group과 아이템의 비율
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing: CGFloat = 0

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5545))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: bookMarkCollectionView) {  collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(itemIdentifier.name)
            return cell
        }
        dataSource.apply(filteredItemSanpshot)
    }

}


extension BookmarkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let findString = searchController.searchBar.text, !findString.isEmpty {
            filterdItem = dummyData.filter{ $0.name.lowercased().contains(findString.lowercased()) }
        } else {
            filterdItem = dummyData
        }
        
        dataSource.apply(filteredItemSanpshot, animatingDifferences: true)
    }
}
