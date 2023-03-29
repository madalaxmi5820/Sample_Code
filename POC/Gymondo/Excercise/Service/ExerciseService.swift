//
//  ExerciseService.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 30/12/22.
//

import Foundation

final class ExerciseService {
    
    func fetchExercises(requestURL: String,
                        success: @escaping (ExercisesModel.Response.Exercises?) -> (),
                        fail: @escaping (_ errorHandler: Error) -> ()) {
        
        guard let url = URL(string: requestURL) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) {(jsonData, response, error) in
            if let error = error {
                fail(error)
                success(nil)
                return
            }
            
            do {
                guard let jsonData = jsonData else { return }
                do {
                    let decoder = JSONDecoder()
                    let exercisesObject = try decoder.decode(ExercisesModel.Response.Exercises.self, from: jsonData)
                    success(exercisesObject)
                } catch {
                    print(error)
                    success(nil)
                }
            }
        }.resume()
    }

    func fetchExerciseInfo(requestURL: String,
                           exerciseId: Int,
                           success: @escaping (ExerciseInfoModel.Response.ExeriseInfo?) -> (),
                           fail: @escaping (_ errorHandler: Error) -> ()) {
        
        guard let url = URL(string: requestURL + String(exerciseId)) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) {(jsonData, response, error) in
            if let error = error {
                fail(error)
                success(nil)
                return
            }
            do {
                guard let jsonData = jsonData else { return }
                do {
                    let decoder = JSONDecoder()
                    let exerciseInfo = try decoder.decode(ExerciseInfoModel.Response.ExeriseInfo.self, from: jsonData)
                    success(exerciseInfo)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
