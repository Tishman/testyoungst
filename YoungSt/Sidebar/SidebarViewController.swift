//
//  SidebarViewController.swift
//  YoungSt
//
//  Created by Nikita Patskov on 27.05.2021.
//

import UIKit
import Resources
import ComposableArchitecture
import Combine

private typealias SidebarItemIdentifier = TabItem

private enum SidebarListItem: Hashable {
    case header(String)
    case content(SidebarListContent)
    
    var text: String {
        switch self {
        case let .content(content):
            return content.text
        case let .header(text):
            return text
        }
    }
}

private struct SidebarListContent: Hashable {
    let id: SidebarItemIdentifier
    
    var text: String { id.title }
    var imageName: String { id.imageName }
}

private enum SidebarListSection: Int, Hashable {
    case base
}

final class SidebarViewController: UIViewController {
    private let collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        #if !targetEnvironment(macCatalyst)
        config.backgroundColor = UIColor.secondarySystemBackground
        #endif
        config.headerMode = .none
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<SidebarListSection, SidebarListItem>?
    
    private let items: [SidebarListItem] = TabItem.allCases.map { .content(.init(id: $0)) }
    
    private let accentColor: UIColor = Asset.Colors.greenDark.color
    private let store: Store<TabState, TabAction>
    private let viewStore: ViewStore<TabState, TabAction>
    private var bag = Set<AnyCancellable>()
    
    init(store: Store<TabState, TabAction>) {
        self.store = store
        self.viewStore = .init(store)
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SidebarCell.self, forCellWithReuseIdentifier: SidebarCell.reuseID)
        setupCollectionView()
        setupLayout()
  
        viewStore.publisher.selectedTab
            .sink(receiveValue: { [weak collectionView] selectedItem in
                collectionView?.selectItem(at: .init(item: selectedItem.rawValue, section: SidebarListSection.base.rawValue),
                                           animated: true,
                                           scrollPosition: .top)
            })
            .store(in: &bag)
        
        #if targetEnvironment(macCatalyst)
        updateForMac()
        #else
        updateStyles()
        #endif
    }
    
    private func updateStyles() {
        navigationItem.title = "Young st."
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = accentColor
        view.backgroundColor = UIColor.systemBackground
    }
    
    private func updateForMac() {
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateList()
        collectionView.selectItem(at: .init(item: viewStore.selectedTab.rawValue, section: SidebarListSection.base.rawValue),
                                  animated: false,
                                  scrollPosition: .top)
    }
    
    private func setupCollectionView() {
        dataSource = makeDataSource()
        collectionView.backgroundColor = .clear
        // Delegates
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension SidebarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch items[indexPath.row] {
        case .content:
            return true
        default:
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.row] {
        case let .content(content):
            viewStore.send(.selectedTabShanged(content.id))
        default:
            break
        }
    }
}

private extension SidebarViewController {
    
    func makeHeaderRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        UICollectionView.CellRegistration { cell, index, item in
            var config = UIListContentConfiguration.sidebarHeader()
            config.text = item
            config.textProperties.font = .systemFont(ofSize: 14, weight: .medium)
            
            var backgroundConfig = UIBackgroundConfiguration.listSidebarHeader()
            backgroundConfig.backgroundColor = .clear
            
            cell.backgroundConfiguration = backgroundConfig
            cell.contentConfiguration = config
            cell.tintColor = self.accentColor
            
        }
    }
    
    func makeRowRegistration() -> UICollectionView.CellRegistration<SidebarCell, SidebarListContent> {
        
        UICollectionView.CellRegistration { cell, index, item in
            var config = UIListContentConfiguration.sidebarCell()
            config.image = UIImage(systemName: item.imageName)
            config.text = item.text
            cell.contentConfiguration = config
            cell.tintColor = self.accentColor
            
            var backgroundConfig = UIBackgroundConfiguration.listSidebarCell()
            backgroundConfig.backgroundColor = .clear
            cell.backgroundConfiguration = backgroundConfig
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<SidebarListSection, SidebarListItem> {
        let rowRegistration = makeRowRegistration()
        let headerRegistration = makeHeaderRegistration()
        
        return UICollectionViewDiffableDataSource<SidebarListSection, SidebarListItem>(
            collectionView: collectionView,
            cellProvider: { view, indexPath, item in
                switch item {
                case let .header(text):
                    return view.dequeueConfiguredReusableCell(
                        using: headerRegistration,
                        for: indexPath,
                        item: text
                    )
                    
                case let .content(content):
                    let cell = view.dequeueConfiguredReusableCell(
                        using: rowRegistration,
                        for: indexPath,
                        item: content
                    )
                    
                    cell.automaticallyUpdatesBackgroundConfiguration = false
                    return cell
                }
            }
        )
    }
    
    func updateList() {
        var snapshot = NSDiffableDataSourceSnapshot<SidebarListSection, SidebarListItem>()
        snapshot.appendSections([.base])
        snapshot.appendItems(items, toSection: .base)
        dataSource?.apply(snapshot)
    }
}

private class SidebarCell: UICollectionViewCell {
    
    static let reuseID = "SidebarCell"
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var back = UIBackgroundConfiguration.listSidebarCell().updated(for: state)
        let selectedColor: UIColor
        #if targetEnvironment(macCatalyst)
        selectedColor = .systemGray4
        back.cornerRadius = .corner(.small)
        #else
        selectedColor = Asset.Colors.greenDark.color
        #endif
        
        back.backgroundColor = state.isSelected ? selectedColor : .clear
        self.backgroundConfiguration = back
    }
}
