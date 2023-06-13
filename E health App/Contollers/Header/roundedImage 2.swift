//
//  roundedImage.swift
//  E health App
//
//  Created by Ranjan on 18/08/21.
//

import Foundation
import UIKit

@IBDesignable public class RoundedImageView: UIImageView {

    override public func layoutSubviews() {
        super.layoutSubviews()

        //hard-coded this since it's always round
        layer.cornerRadius = 0.5 * bounds.size.width
    }
}
