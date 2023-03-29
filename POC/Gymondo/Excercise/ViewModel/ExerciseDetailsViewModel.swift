//
//  ExerciseDetailsViewModel.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 01/01/23.
//

import Foundation

class ExerciseDetailsViewModel{
    
    var id: Int?
    var name: String?
    var description: String?
    var imageDataSource = [ImageCellViewModel]()
    var variations = [Int]()
    
    private var exerciseService: ExerciseService!
    /// Callback to reload the table.
    var reloadTable: ()->() = { }
        
    /// Callback to Error.
    var fetchExercisesError: (_ error: Error?)->() = { _ in }
    
    var dataModel: ExerciseInfoModel.Response.ExeriseInfo? {
        didSet {
            configureOutput()
        }
    }
    
    init() {
        self.exerciseService = ExerciseService()
    }
    
    private func configureOutput() {
        self.id = dataModel?.id ?? 0
        self.name = dataModel?.name ?? ""
        self.description = dataModel?.description ?? ""
        self.variations = dataModel?.variations ?? []
        updateImageURLs()
    }
    
    func updateImageURLs() {
        var images = [String]()
        if let imageUrls = dataModel?.images {
            imageUrls.forEach { image in
                images.append(image.image ?? "")
            }
        }
        if images.count > 0 {
            self.imageDataSource = images.map {  return ImageCellViewModel(imageUrl: $0) }
        }
    }
    
    
    func fetchExerciseInfo(exerciseId: Int) {
        ExerciseService().fetchExerciseInfo(requestURL: EXERCISE_INFO_URl, exerciseId: exerciseId, success: { response in
            guard let response = response else {return}
            self.dataModel = response
            self.reloadTable()
        }, fail: { error in
            self.fetchExercisesError(error)
        })
    }
}
