//
//  UIImageView + downloadedFrom.swift
//  ElectriDash
//
//  Created by Ruben Assink on 14/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        self.image = UIImage()
        self.alpha = 1

        let activityView = Helper.setCenterActivityIndicator(view: self)
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                activityView.stopAnimating()
                self.alpha = 0
                self.image = image
                UIView.animate(withDuration: 0.2,
                               animations: { self.alpha = 1 },
                               completion: nil)
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
