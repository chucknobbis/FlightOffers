//
//  Slide.swift
//  FlightOffers
//
//  Created by Kris Flajs on 10.09.19.
//  Copyright © 2019 eRazred. All rights reserved.
//

import UIKit

class Slide: UIView {
    
    @IBOutlet weak var lFrom: UILabel!
    @IBOutlet weak var lTo: UILabel!
    @IBOutlet weak var lPrice: UILabel!
    @IBOutlet weak var lDeparture: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    
}

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
