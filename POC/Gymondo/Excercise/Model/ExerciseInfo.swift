//
//  ExeriseInfo.swift
//  Gymondo ----
//
//  Created by Mada, Venkata Lakshmi on 29/12/22.
//

import Foundation

struct ExerciseInfoModel {
    
    struct Response {
        
        struct ExeriseInfo: Codable {
            let id: Int?
            let name: String?
            let description: String?
            let images: [Image]?
            let variations: [Int]?
            
            enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
                case images = "images"
                case description = "description"
                case variations = "variations"
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                description = try values.decodeIfPresent(String.self, forKey: .description)
                images = try values.decodeIfPresent([Image].self, forKey: .images)
                variations = try values.decodeIfPresent([Int].self, forKey: .variations)
            }
            
            // MARK: - Image
            struct Image: Codable {
                let id: Int?
                let image: String?
                
                enum CodingKeys: String, CodingKey {
                    case id = "id"
                    case image = "image"
                }
                
                init(from decoder: Decoder) throws {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    id = try values.decodeIfPresent(Int.self, forKey: .id)
                    image = try values.decodeIfPresent(String.self, forKey: .image)
                }
            }
        }
    }
}
