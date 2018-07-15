//
//  UIImage+Extensions.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 12/07/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
