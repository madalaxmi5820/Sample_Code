//
//  ExerciseCollectionViewCell.swift
//  Gymondo
//
//  Created by Mada, Venkata Lakshmi on 30/12/22.
//

import UIKit
import Kingfisher

class ExerciseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var feedImageView: UIImageView!
    private var viewModel: ImageCellViewModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.image = nil
    }
    
    func prepareCell(with viewModel: ImageCellViewModel?, placeholderImage: UIImage?) {
        self.viewModel = viewModel
        setImage(placeholderImage: placeholderImage)
    }
    
    func setImage(placeholderImage: UIImage?) {
        if let url = viewModel?.imageUrl {
            feedImageView.kf.setImage(
                with: URL(string: url),
                placeholder: placeholderImage) { result in
                switch result {
                case .success(_): break
                case .failure(let error):
                    print("Image Load failed: \(error.localizedDescription)")
                    self.feedImageView.image = placeholderImage
                }
            }
        } else {
            feedImageView.image = placeholderImage  
        }
    }
}
