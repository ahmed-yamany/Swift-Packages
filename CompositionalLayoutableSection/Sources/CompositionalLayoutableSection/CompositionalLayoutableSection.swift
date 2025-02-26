//
//  CollectionViewModelSectionType.swift
//  iCinema
//
//  Created by Ahmed Yamany on 05/02/2023.
//

import UIKit

public protocol UICompositionalLayoutableSectionDataSource: UICollectionViewDataSource {}

public protocol UICompositionalLayoutableSectionDataSourcePrefetching: UICollectionViewDataSourcePrefetching { }

public protocol UICompositionalLayoutableSectionLayout: AnyObject {
    func sectionLayout(at index: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
}

@objc public protocol UICompositionalLayoutableSectionDelegate: UICollectionViewDelegate {
    @objc func registerCell(in collectionView: UICollectionView)
    @objc optional func registerSupplementaryView(in collectionView: UICollectionView)
    @objc optional func registerDecorationView(in layout: UICollectionViewCompositionalLayout)
}

/*
 - This class defines a four optional properties that hold objects
   conforming to the three protocols a section in the compositional layout should implement

 - Using this can lead to better organization and abstraction of your code,
   as well as making it easier to reuse and maintain.

 - You can create multiple objects Inherets from this class
   and switch between them to show different sections in the same collection view,
 */
@MainActor
open class CompositionalLayoutableSection: NSObject {
    open weak var dataSource: (any UICompositionalLayoutableSectionDataSource)?
    open weak var prefetchDataSource: (any UICompositionalLayoutableSectionDataSourcePrefetching)?
    open weak var sectionLayout: (any UICompositionalLayoutableSectionLayout)?
    open weak var delegate: (any UICompositionalLayoutableSectionDelegate)?
    
    public weak var collectionView: UICollectionView?
    public var index: Int?
    
    public func reloadData() {
        guard let collectionView else {
            debugPrint("couldn't reload data because collectionView is nil")
            return
        }
        
        guard let index else {
            debugPrint("couldn't reload data because section index couldn't be recoginzed")
            return
        }
        
        collectionView.reloadSections(IndexSet(integer: index))
    }
}
