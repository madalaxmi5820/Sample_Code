//
//  ExerciseDetailsViewController.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 01/01/23.
//

import UIKit

class ExerciseDetailsViewController: UIViewController {
        
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: ExerciseCollectionView!
    @IBOutlet weak var detailsTableView: UITableView!
    private var viewModel = ExerciseDetailsViewModel()
    
    private var exerciseId: Int?
    private var shouldShowVariations: Bool = false
    
    required init(exerciseId: Int, showVariations: Bool = false) {
        self.exerciseId = exerciseId
        self.shouldShowVariations = showVariations 
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = EXERCISE_DETAILS
        setUpCollectionView()
        loadExercisesList()
        updateUI()
    }
    
    func updateData() {
        detailsTableView.isHidden = true
        pageControl.isHidden = false
        pageControl.numberOfPages = (viewModel.imageDataSource.count > 1) ? viewModel.imageDataSource.count : 0
        titleLabel.text = viewModel.name
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = .zero
        descriptionTextView.text = viewModel.description
        collectionView.updateUI(imageDataSource: viewModel.imageDataSource, placeholderImage: UIImage(named:"placeholderImage")!)
        self.collectionView.updateCurrentIndex = { index in
            self.pageControl.currentPage = index
        }
    }

    private func updateUI() {
        viewModel.reloadTable = {
            DispatchQueue.main.async {
                //self.hideProgressHUD()
                self.updateData()
                if (self.viewModel.variations.count > 0 &&  self.shouldShowVariations) {
                    self.detailsTableView.delegate = self
                    self.detailsTableView.dataSource = self
                    self.detailsTableView.reloadData()
                    self.detailsTableView.isHidden = false
                } else {
                    self.detailsTableView.isHidden = true
                }
                
            }
        }
        
        viewModel.fetchExercisesError = { error in
            if let errorHandler = error {
                // Show alert
                print(errorHandler)
            }
        }
    }
    
    private func loadExercisesList() {
        viewModel.fetchExerciseInfo(exerciseId: self.exerciseId ?? 0)
    }
    
    private func setUpCollectionView() {
        self.collectionView.register(UINib(nibName: ExerciseTableViewCell.kExerciseCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: ExerciseTableViewCell.kExerciseCollectionViewCell)
    }
}

extension ExerciseDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataModel?.variations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let variationsCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "variationsCell")
        variationsCell.textLabel?.text = String(viewModel.variations[indexPath.row])
        return variationsCell
    }
}

// MARK:- UITableViewDelegate

extension ExerciseDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let execiseId = viewModel.variations[indexPath.row]
        self.navigateToDetailsViewController(variationInfo: execiseId)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Variations"
    }
}


extension ExerciseDetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ExerciseDetailsViewController {
    func navigateToDetailsViewController(variationInfo: Int) {
        let detailsViewController = ExerciseDetailsViewController.init(exerciseId: variationInfo)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
