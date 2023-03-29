//
//  ExercisesListViewModel.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 30/12/22.
//

import Foundation

class ExercisesListViewModel {
    
    private var exerciseService: ExerciseService!
    
    // Output
    var numberOfRows = 0
    
    var dataSource = [ExerciseListCellViewModel]()
    
    /// Callback to reload the table.
    var reloadTable: ()->() = { }
    
    /// Callback to display table
    var exercisesFetched = { }
    
    /// Callback to display table
    var exerciseInfoFetched: (_ indexPath: IndexPath?) ->() = {_ in}
    
    /// Callback to Error.
    var fetchExercisesError: (_ error: Error?)->() = { _ in }
    
    var dataModel: ExercisesModel.Response.Exercises! {
        didSet {
            if dataModel != nil {
                self.exercisesFetched()
                prepareTableDataSource()
            }
        }
    }
    
    init() {
        self.exerciseService = ExerciseService()
    }
    
    func fetchExercisesList() {
        ExerciseService().fetchExercises(requestURL: EXERCISE_LIST_URl) { data in
            self.dataModel = data
        } fail: { error in
            self.fetchExercisesError(error)
        }
    }
    
    func fetchExerciseInfo(exerciseId: Int, indexPath: IndexPath) {
        ExerciseService().fetchExerciseInfo(requestURL: EXERCISE_INFO_URl, exerciseId: exerciseId, success: { response in
            self.updateImageUrl(response: response)
            self.exerciseInfoFetched(indexPath)
        }, fail: { error in
            self.fetchExercisesError(error)
        })
    }
    
    func updateImageUrl(response : ExerciseInfoModel.Response.ExeriseInfo?) {
        if let response = response {
            if (response.images?.count ?? 0 > 0){
                let cellViewModel = dataSource.filter{ $0.id == response.id }
                if (cellViewModel.count > 0) {
                    var imageURLs = [String]()
                    response.images?.forEach { info in
                        imageURLs.append(info.image ?? "")
                    }
                    cellViewModel[0].updateImageURL(imageURLs: imageURLs)
                }
            }
        }
    }
    
    func prepareTableDataSource() {
        self.dataSource = dataModel.results!.map {  return ExerciseListCellViewModel(model: $0) }
       
        self.configureNumberOfRows()
        self.reloadTable()
        for (index, exercise) in self.dataSource.enumerated() {
            self.fetchExerciseInfo(exerciseId: exercise.id ?? 0, indexPath: IndexPath(row: index, section: 0))
        }
    }
    
    func configureNumberOfRows() {
        self.numberOfRows = self.dataSource.count
    }
    
    func cellViewModel(index: Int) -> (ExerciseListCellViewModel) {
        let cellViewModel = dataSource[index]
        return cellViewModel
    }
    
    func resetData() {
        numberOfRows = 0
        dataSource.removeAll()
        dataModel = nil
    }
}
