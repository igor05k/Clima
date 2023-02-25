//
//  UIImageView+.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import UIKit

extension UIImageView {
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
