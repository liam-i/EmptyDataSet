//
//  CustomViewController.swift
//  EmptyDataSet
//
//  Created by Liam on 2020/2/11.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit
import LPEmptyDataSet
import LPHUD

private let reuseIdentifier = "Cell"
class CustomViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var dataNumber: Int = 0
    private var isFailed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Custom"
        edgesForExtendedLayout = []
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }

    @IBAction func emptyDataButtonClicked(_ sender: UIBarButtonItem) {
        switch collectionView.dataLoadStatus {
        case .loading:
            dataNumber = 10
            collectionView.dataLoadStatus = .success
        case .success:
            dataNumber = 0
            collectionView.dataLoadStatus = .failed
        case .failed:
            dataNumber = 0
            self.collectionView.dataLoadStatus = .loading
            HUD.show(to: collectionView, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                HUD.hide(for: self.collectionView, animated: true)
                self.isFailed.toggle()
                self.dataNumber = self.isFailed ? 0 : 50
                self.collectionView.dataLoadStatus = .success
            }
        default:
            self.dataNumber = 100
            collectionView.dataLoadStatus = .success
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataNumber
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.red
        return cell
    }
}

extension CustomViewController: EmptyDataSetDataSource, EmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        switch scrollView.dataLoadStatus {
        case .loading:  return false
        default:        return true
        }
    }

    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let image = scrollView.dataLoadStatus == .failed ? #imageLiteral(resourceName: "placeholder_vine") : #imageLiteral(resourceName: "icon_wwdc")
        return UIImageView(image:  image)
    }

//    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//        return scrollView.emptyDataSetType == .error ? #imageLiteral(resourceName: "placeholder_vine") : #imageLiteral(resourceName: "icon_wwdc")
//    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
