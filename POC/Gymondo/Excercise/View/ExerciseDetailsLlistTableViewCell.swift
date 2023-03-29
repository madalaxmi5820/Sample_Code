//
//  ExerciseDetailsLlistTableViewCell.swift
//  Gymondo
//
//  Created by Nukala, Raja | RIEPL on 02/05/22.
//

import UIKit

class ExerciseDetailsLlistTableViewCell: UITableViewCell {

    
    @IBOutlet weak private var collectionView: ExerciseCollectionView!
    @IBOutlet weak private var pageControl: UIPageControl!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var pageControllerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var viewModel: ExerciseDetailsViewModel!
    var tapAtIndex: (Int)->() = { _ in }
    static let kExerciseCollectionViewCell = "ExerciseCollectionViewCell"
    var placeholderImage = UIImage()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        setUpThemeColor()
        setUpCollectionView()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        applyShadow(view: self.containerView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
        self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
        self.pageControl.currentPage = 0
    }
    
    func prepareDetailsViewCell(viewModel: ExerciseDetailsViewModel, placeholderImage: UIImage) {
        self.placeholderImage = placeholderImage
        self.viewModel = viewModel
        setCellData()
        updateCellUI()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData() {
        self.titleLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.description
        self.collectionView.updateUI(imageDataSource: viewModel.imageDataSource, placeholderImage: self.placeholderImage)
        self.collectionView.updateCurrentIndex = { index in
            self.pageControl.currentPage = index
        }
        self.collectionView.tapAtIndex = { index in
            self.tapAtIndex(index)
        }
    }
    
    func applyShadow(view: UIView){
        let shadowPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 1.0, height: 1.0)).cgPath
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.shadowPath = shadowPath
    }
    
    private func updateCellUI() {
        self.containerView.layer.cornerRadius = 15.0
        if viewModel.imageDataSource.count <= 1 {
            self.pageControllerHeightConstraint.constant = 0
            self.pageControl.isHidden = true
        } else {
            self.pageControllerHeightConstraint.constant = 30
            self.pageControl.numberOfPages = viewModel.imageDataSource.count
            self.pageControl.isHidden = false
        }
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
    }
    
    private func setUpCollectionView() {
        self.collectionView.register(UINib(nibName: ExerciseTableViewCell.kExerciseCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: ExerciseTableViewCell.kExerciseCollectionViewCell)
    }
    
}
