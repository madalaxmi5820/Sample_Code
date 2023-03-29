//
//  ExerciseViewController.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 29/12/22.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    static let kExerciseTableViewCell = "ExerciseTableViewCell"
    
    @IBOutlet weak var exerciseTableView: UITableView!
    private var viewModel = ExercisesListViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExercisesList()
        updateUI()
        setUpStoreListTableView()
        setUpPullToRefresh()
        self.title = "Exercises"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setUpStoreListTableView() {
        self.exerciseTableView.separatorStyle = .none
        self.exerciseTableView.register(UINib(nibName: ExerciseViewController.kExerciseTableViewCell, bundle: nil), forCellReuseIdentifier: ExerciseViewController.kExerciseTableViewCell)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.exerciseTableView.delegate = nil
        self.exerciseTableView.dataSource = nil
        viewModel.resetData()
        loadExercisesList()
        refreshControl.endRefreshing()
    }
    
    private func setUpPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.exerciseTableView.addSubview(refreshControl)
    }
    
    private func updateUI() {
        viewModel.reloadTable = {
            DispatchQueue.main.async {
                self.exerciseTableView.delegate = self
                self.exerciseTableView.dataSource = self
                self.exerciseTableView.reloadData()
                self.exerciseTableView.isHidden = false
            }
        }
        
        viewModel.fetchExercisesError = { error in
            self.viewModel.resetData()
            if let errorHandler = error {
                // Show alert
                print(errorHandler)
            }
        }
        
        viewModel.exerciseInfoFetched = { indexPath in
            DispatchQueue.main.async {
                self.exerciseTableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.none)
            }
        }
    }
    
    private func loadExercisesList() {
        viewModel.fetchExercisesList()
    }
}

// MARK:- UITableViewDataSource

extension ExerciseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseViewController.kExerciseTableViewCell, for: indexPath) as! ExerciseTableViewCell
        let cellViewModel = viewModel.cellViewModel(index: indexPath.row)
        cell.prepareCell(viewModel: cellViewModel,
                         placeholderImage: UIImage(named: "placeholderImage")!)
        cell.tapAtIndex = { index in
            self.navigateToDetailsViewController(id: cellViewModel.id ?? 0)
        }
        return cell
    }
}

// MARK:- UITableViewDelegate

extension ExerciseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cellViewModel = viewModel.cellViewModel(index: indexPath.row)
        self.navigateToDetailsViewController(id: cellViewModel.id ?? 0)
    }
}


extension ExerciseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ExerciseViewController {
    func navigateToDetailsViewController(id: Int) {
        let detailsViewController = ExerciseDetailsViewController.init(exerciseId: id, showVariations: true)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
