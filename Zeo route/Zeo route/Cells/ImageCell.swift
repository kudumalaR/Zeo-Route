//
//  ImageCell.swift
//  Zeo route
//
//  Created by Kudumala on 18/03/25.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with urlString: String?) {
        guard let urlString = urlString else { return }
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            self.imageView.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }
            
            ImageCache.shared.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        task.resume()
    }
}
