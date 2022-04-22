//
//  UIImage.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/02.
//

import UIKit

extension UIImage {
    
    func scaled(to size: CGSize) -> UIImage {
        let originalRatio = self.size.width / self.size.height
        let referenceRatio = size.width / size.height
        let ratio = originalRatio > referenceRatio ? size.height / self.size.height : size.width / self.size.width
        let sizeByRatio = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let image = UIGraphicsImageRenderer(size: sizeByRatio).image { _ in
            draw(in: CGRect(origin: .zero, size: sizeByRatio))
        }
        return image.withRenderingMode(renderingMode)
    }
}
