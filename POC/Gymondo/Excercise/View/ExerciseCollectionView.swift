//
//  ExerciseCollectionView.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 30/12/22.
//

import Foundation
import UIKit

class ExerciseCollectionView: UICollectionView {
    
    var imageDataSource = [ImageCellViewModel]()
    var updateCurrentIndex: (Int)->() = { _ in }
    var tapAtIndex: (Int)->() = { _ in }
    var placeholderImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    private func setUpCollectionView() {
        self.isPagingEnabled = true
    }
    
    func updateUI(imageDataSource: [ImageCellViewModel], placeholderImage: UIImage) {
        self.imageDataSource = imageDataSource
        self.placeholderImage = placeholderImage
        self.dataSource = self
        self.delegate = self
    }
}


extension ExerciseCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapAtIndex(collectionView.tag)
    }
}

extension ExerciseCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageDataSource.count > 0) ? imageDataSource.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseTableViewCell.kExerciseCollectionViewCell, for: indexPath) as! ExerciseCollectionViewCell
        cell.prepareCell(with:
                            (imageDataSource.count > 0) ? imageDataSource[indexPath.row] : nil,
                         placeholderImage: self.placeholderImage)
        return cell
    }
}

extension ExerciseCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ExerciseCollectionView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        updateCurrentIndex(currentIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        updateCurrentIndex(currentIndex)
    }
}
