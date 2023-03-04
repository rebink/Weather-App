//
//  UIImage+Extension.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(with urlString: String, placeholder: UIImage? = nil) {
        let url = URL(string: urlString)
        self.kf.setImage(with: url, placeholder: placeholder)
    }
    
}
