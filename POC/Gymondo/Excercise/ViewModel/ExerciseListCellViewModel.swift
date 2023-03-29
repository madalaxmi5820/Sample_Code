//
//  ExerciseListCellViewModel.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 30/12/22.
//

import Foundation

class ExerciseListCellViewModel {
    
    var id: Int?
    var title: String?
    var imageUrls: [String]?
    var exercise: ExercisesModel.Response.Exercises.Exercise?
    var imageDataSource = [ImageCellViewModel]()
    
    init(model: ExercisesModel.Response.Exercises.Exercise) {
        exercise = model
        configureOutput()
    }
    
    func updateImageURL(imageURLs: [String]) {
        self.imageUrls = imageURLs
        self.imageDataSource = imageUrls!.map {  return ImageCellViewModel(imageUrl: $0) }
    }
    
    func configureOutput() {
        self.id = exercise?.id ?? nil
        self.title = exercise?.name ?? ""
    }
    
    func imageCellViewModel(indexPath: IndexPath) -> (ImageCellViewModel) {
        let imageCellViewModel = imageDataSource[indexPath.row]
        return imageCellViewModel
    }
}
